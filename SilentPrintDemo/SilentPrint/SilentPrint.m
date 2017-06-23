//
//  SilentPrint.m
//  SilentPrintDemo
//
//  Created by cuong on 4/27/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "SilentPrint.h"

@implementation SilentPrint

+(SilentPrint*) getSingleton
{
    static SilentPrint *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [SilentPrint new];
        _sharedInstance.printInProgress = false;
        _sharedInstance.pendingFileIndex = NO_PENDING_FILE_PRINT; //Nothing pending from previous print
        
    });
    return _sharedInstance;
}

/* Raise error to outter application
 */
-(void)raiseError: (NSInteger) errorCode {
    //make sure delegate is not nil
    if (!self.silentPrintDelegate) return;
    
    NSString* message = nil;
    switch (errorCode) {
        case PRINTER_IS_NOT_SELECTED:
            message = @"Printer is not selected";
            break;
        case PRINTER_IS_OFFLINE:
            message = @"Printer is offline";
            break;
        case CANNOT_PRINT_FILE_URL:
            message = @"Printer cannot print invalid file URL";
            break;
        case USER_CANCEL_PRINT:
            message = @"User cancels or print fails";
            break;
        default:
            message = @"Unknown error";
            break;
    }
    
    NSError* error = [NSError errorWithDomain: @"SilentPrint"
                                         code: errorCode
                                     userInfo: @{NSLocalizedDescriptionKey: message}
                      ];
    [self.silentPrintDelegate onSilentPrintError:error];
    
}



-(void)configureSilentPrint:(CGRect)rect
                     inView:(UIView *)view
                 completion:(void (^)(void))completionBlock
{
    UIPrinterPickerController *printerPicker = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
    //The selected printer. Set this before presenting the UI to show the currently selected printer. Use this to determine which printer the user selected.
    
    
    // Return selected printer
    [printerPicker presentFromRect: rect
                            inView: view
                          animated: NO
                 completionHandler: ^(UIPrinterPickerController *printerPickerController, BOOL didSelect, NSError *error) {
                     // nếu có lỗi
                     if (error && self.silentPrintDelegate) {
                         [self.silentPrintDelegate onSilentPrintError:error];
                     }
                     // nếu printer đc chọn
                     if (didSelect) {
                         // gắn vào singleton
                         self.selectedPrinter = printerPickerController.selectedPrinter;
                         completionBlock();
                     } else {
                         [self raiseError: PRINTER_IS_NOT_SELECTED];
                     }
                 }];
}

-(UIMarkupTextPrintFormatter *)printHTML:(NSString *)currentFilePath
{
    NSString* content1 = [NSString stringWithContentsOfFile:currentFilePath
                                                   encoding:NSUTF8StringEncoding
                                                      error:NULL];
    
    UIMarkupTextPrintFormatter *htmlFormatter = [[UIMarkupTextPrintFormatter alloc]
                                                 initWithMarkupText:content1];
    //htmlFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    
    // iOS 10.0
    htmlFormatter.perPageContentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0);
    return htmlFormatter;
}

/* 
 */
-(void) printUIView: (UIView*) view
            jobName: (NSString*)jobName
               show: (BOOL) show {
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = jobName;
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    
    UIPrintInteractionController* printController = [UIPrintInteractionController sharedPrintController];
    printController.printInfo = printInfo;
    printController.delegate = self;
    
    printController.printFormatter = [view viewPrintFormatter];
    
    [self.selectedPrinter contactPrinter:^(BOOL available) {
        if (!available) {//Printer is Not available
            [self raiseError: PRINTER_IS_OFFLINE];
            return;
        } else {
            
            if (!show) {  //SILENT MODE
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    [printController printToPrinter:self.selectedPrinter
                                  completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
                                      if (error) {
                                          [self.silentPrintDelegate onSilentPrintError:error];
                                      }
                                      if (completed) {
                                          // Gọi hàm callback
                                          if (self.silentPrintDelegate && [(id)self.silentPrintDelegate respondsToSelector:@selector(onPrintFileComplete:withJob:)]) {
                                              [self.silentPrintDelegate onPrintFileComplete:0
                                                                                    withJob:printInteractionController.printInfo.jobName];
                                          }
                                          
                                      }
                                      
                                  }]; //[printController printToPrinter:self.selectedPrinter
                });  //dispatch_async
                
            } else {  //INTERACTIVE MODE
                printController.showsPaperSelectionForLoadedPapers = YES;
                [printController presentAnimated:true completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
                    @synchronized (self) {
                        self.printInProgress = false;
                        self.filePaths = nil;
                    }
                    if (error) {
                        [self.silentPrintDelegate onSilentPrintError:error];
                    } else if (!completed) {
                        [self raiseError:USER_CANCEL_PRINT];
                    } else {  //Print interactively complete
                        if (self.silentPrintDelegate && [(id)self.silentPrintDelegate respondsToSelector:@selector(onPrintFileComplete:withJob:)]) {
                            [self.silentPrintDelegate onPrintFileComplete:0
                                                                  withJob:printInteractionController.printInfo.jobName];
                        }
                    }
                    
                }];
                
            }
        }
    }];  //self.selectedPrinter contactPrinter
    
    
    
}
-(void) printBatch: (NSArray *)filePaths
     andShowDialog: (Boolean)show
{
    if (!filePaths) return;
    
    if (self.printInProgress) { //If silent print is printing then append
        @synchronized (self) {
            //Check if printing is in progress, then append array !
            NSArray* arrayAfterAppend = [self.filePaths arrayByAddingObjectsFromArray:filePaths];
            self.filePaths = arrayAfterAppend;
        }
        
    } else {
        @synchronized (self) {
            self.printInProgress = true;
            self.numberPrintFail = 0;
            self.numberPrintSuccess = 0;
            self.filePaths = filePaths;
        }
        
        [self printFile:0
          andShowDialog:show];

        
    }
}
//Retry to print after user reconfigure or select new printer
- (void) retryPrint {
    if (self.filePaths.count == 0 || self.pendingFileIndex == NO_PENDING_FILE_PRINT) return;
    
    if (self.pendingFileIndex >= 0 && self.pendingFileIndex < self.filePaths.count) {
        @synchronized (self) {
            self.printInProgress = true;
            self.numberPrintFail = 0;
            self.numberPrintSuccess = 0;
        }
        [self printFile: self.pendingFileIndex //start from pending file Index
          andShowDialog: false];
    }
    
}

/*
 print single file in silent mode is equal to print a batch file which has only one item and does not show dialog
 */

-(void) printFile: (NSString*) filePath
         inSilent: (Boolean) silent{
    if (filePath) {
        [self printBatch:@[filePath] andShowDialog:!silent];
    }
}


-(void) printBatch: (NSArray *)filePaths {
    if (filePaths.count > 1) {
        [self printBatch:filePaths andShowDialog:false];  //Silent Print
    } else {
        [self printBatch:filePaths andShowDialog:true];  //filePath has only one item, then show printing dialog
    }
}



/*
 * Handle when [UIPrintInteractionController canPrintURL:fileURL] return false
 * support to print html, htm and txt, csv, log files
 */
-(UIPrintFormatter*) generatePrintFormater: (NSURL*) fileURL {
    NSString* fileExtension = [fileURL pathExtension];
       NSString* fileContent = [NSString stringWithContentsOfFile: fileURL.path
                                                      encoding: NSUTF8StringEncoding
                                                         error: NULL];
    UIPrintFormatter* printFormatter;
    
    if ([fileExtension isEqualToString:@"html"] || [fileExtension isEqualToString:@"htm"]) {
        printFormatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText: fileContent];  //Markup
        
    } else if ([fileExtension isEqualToString:@"txt"] ||
               [fileExtension isEqualToString:@"csv"] ||
               [fileExtension isEqualToString:@"log"] ) {
        printFormatter = [[UISimpleTextPrintFormatter alloc] initWithText: fileContent];  //Simple text
    } else {
        return nil;
    }
    
    printFormatter.perPageContentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0);
    return printFormatter;
}

/*
 * fileIndex: order of file to print in array filePaths
 *
 */
-(void) printFile: (int)fileIndex
    andShowDialog: (Boolean)show
{
    if (!self.selectedPrinter) {
        @synchronized (self) {
            self.printInProgress = false;
            self.pendingFileIndex = fileIndex;
        }
        [self raiseError: PRINTER_IS_NOT_SELECTED];
        return;
    }
    
    //Reach end of the priting queue
    if (fileIndex == self.filePaths.count) {
        
        @synchronized (self) {
            self.printInProgress = false;  //printing is done
            self.filePaths = nil;          //there is empy pending print queue
            self.pendingFileIndex = NO_PENDING_FILE_PRINT;
        }
        
        if (self.silentPrintDelegate && [(id)self.silentPrintDelegate respondsToSelector:@selector( onPrintBatchComplete:andFail:)]) {
            [self.silentPrintDelegate onPrintBatchComplete:self.numberPrintSuccess
                                                   andFail:self.numberPrintFail];
        }        
        return;
    }
    
    
    UIPrintFormatter* printFormatter = nil;
    
    NSString* filePath = self.filePaths[fileIndex];
    NSURL* fileURL = [NSURL fileURLWithPath: filePath];
    if (![UIPrintInteractionController canPrintURL:fileURL]) {
        printFormatter = [self generatePrintFormater:fileURL];
        if (!printFormatter) {
            [self raiseError: CANNOT_PRINT_FILE_URL];
            self.numberPrintFail += 1;
            //Move next file
            dispatch_async(dispatch_get_main_queue(), ^{
                [self printFile:fileIndex + 1
                  andShowDialog:false];
            });
            return;
        }
    }
    
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = [fileURL lastPathComponent];
    
    
    UIPrintInteractionController* printController = [UIPrintInteractionController sharedPrintController];
    printController.printInfo = printInfo;
    
    printController.delegate = self;
    
    if (printFormatter) {
        printController.printFormatter = printFormatter;
    } else {
        printController.printingItem = fileURL;
    }
    
    if (self.silentPrintDelegate && [(id)self.silentPrintDelegate respondsToSelector:@selector(tryToContactPrinter:)]) {
        [self.silentPrintDelegate tryToContactPrinter:self.selectedPrinter];
    }
    
    [self.selectedPrinter contactPrinter:^(BOOL available) {
        if (!available) {//Printer is Not available
            @synchronized (self) {
                //Mark pending file index to retry print
                self.pendingFileIndex = fileIndex;
                self.printInProgress = false;                
            }
            [self raiseError: PRINTER_IS_OFFLINE];
            return;
        } else {
            
            if (!show) {  //SILENT MODE
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    [printController printToPrinter:self.selectedPrinter
                                  completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
                                      if (error) {
                                          self.numberPrintFail += 1;
                                          [self.silentPrintDelegate onSilentPrintError:error];
                                      }
                                      if (completed) {
                                          self.numberPrintSuccess += 1;
                                          
                                          // Gọi hàm callback
                                          if (self.silentPrintDelegate && [(id)self.silentPrintDelegate respondsToSelector:@selector(onPrintFileComplete:withJob:)]) {
                                              [self.silentPrintDelegate onPrintFileComplete:fileIndex
                                                                                    withJob:printInteractionController.printInfo.jobName];
                                          }
                                          
                                          //Print the next file in batch
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self printFile:fileIndex + 1
                                                andShowDialog:false];
                                          });
                                      }
                                      
                                  }]; //[printController printToPrinter:self.selectedPrinter
                });  //dispatch_async
                
            } else {  //INTERACTIVE MODE
                printController.showsPaperSelectionForLoadedPapers = YES;
                
                [printController presentAnimated:true completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
                    @synchronized (self) {
                        self.printInProgress = false;
                        self.filePaths = nil;
                    }
                    if (error) {
                        [self.silentPrintDelegate onSilentPrintError:error];
                    } else if (!completed) {
                        [self raiseError:USER_CANCEL_PRINT];
                    } else {  //Print interactively complete
                        if (self.silentPrintDelegate && [(id)self.silentPrintDelegate respondsToSelector:@selector(onPrintFileComplete:withJob:)]) {
                            [self.silentPrintDelegate onPrintFileComplete:fileIndex
                                                                  withJob:printInteractionController.printInfo.jobName];
                        }
                    }
                    
                }];
                
            }
        }
    }];  //self.selectedPrinter contactPrinter
}

#pragma mark - UIPrintInteractionControllerDelegate
- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController
                                 choosePaper:(NSArray<UIPrintPaper *> *)paperList {
   
    UIPrintPaper* paperA4 = [UIPrintPaper bestPaperForPageSize: CGSizeMake(595.2, 841.8) //A4
                                           withPapersFromArray: paperList];    
    return paperA4;
}
@end

