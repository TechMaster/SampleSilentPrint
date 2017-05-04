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
        //_sharedInstance.printInteractionControllerDelegate = _sharedInstance;
    });
    return _sharedInstance;
}
/* Raise error to outter application
 100: printer is not selected
 150: printer is offline
 200: cannot print file URL
 250: user cancel or print fails
 */
-(void)raiseError: (NSInteger) errorCode {
    //make sure delegate is not nil
    if (!self.silentPrintDelegate) return;
    
    NSString* message = nil;
    switch (errorCode) {
        case 100:
            message = @"Printer is not selected";
            break;
        case 150:
            message = @"Printer is offline";
            break;
        case 200:
            message = @"Printer cannot print invalid file URL";
            break;
        case 250:
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
    [printerPicker presentFromRect: rect inView: view animated: NO
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
                         [self raiseError: 100];
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



-(void) printFile: (NSString*)filePath
           silent: (Boolean) silent
       onComplete: (void (^)(void)) complete;
{
    if (!self.selectedPrinter) {
        [self raiseError: 100];
        return;
    }
    
    UIPrintFormatter* printFormatter = nil;
    
    NSURL* fileURL = [NSURL fileURLWithPath: filePath];
    if (![UIPrintInteractionController canPrintURL:fileURL]) {
        printFormatter = [self generatePrintFormater:fileURL];
        if (!printFormatter) {
            [self raiseError:200];
            return;
        }
    }
    
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = [fileURL lastPathComponent];
    //printInfo.duplex = self.selectedPrinter.supportsDuplex;
    
    
    UIPrintInteractionController* printController = [UIPrintInteractionController sharedPrintController];
    printController.printInfo = printInfo;
    
    if (printFormatter) {
        printController.printFormatter = printFormatter;
    } else {
        printController.printingItem = fileURL;
    }
    
    
    if (silent) { //Silent mode
        if (self.silentPrintDelegate && [(id)self.silentPrintDelegate respondsToSelector:@selector(tryToContactPrinter:)]) {
            [self.silentPrintDelegate tryToContactPrinter:self.selectedPrinter];
        }
        
        [self.selectedPrinter contactPrinter:^(BOOL available) {
            if (!available) {
                [self raiseError: 150];
                return;
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    [printController printToPrinter:self.selectedPrinter
                                  completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
                                      if (error || !completed) {
                                          [self.silentPrintDelegate onSilentPrintError:error];
                                      }
                                      if (completed && complete) {
                                          complete();
                                      }
                                  }];
                });
            }
        }];
        
    } else { //Interactive mode
        [printController presentAnimated:true completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
            if (error) {
                [self.silentPrintDelegate onSilentPrintError:error];
            } else if (!completed) {
                [self raiseError:250];
            }
            if (completed && complete) {
                complete();
            }
        }];
    }
    
    
}

-(void) printBatch:(NSArray *)filePaths
{
    if (self.printInProgress) { //If silent print is printing then append
        NSLock *theLock=[NSLock new];
        [theLock lock];
        
        //Check if printing is in progress, then append array !
        NSArray* arrayAfterAppend = [self.filePaths arrayByAddingObjectsFromArray:filePaths];
        self.filePaths = arrayAfterAppend;
        [theLock unlock];
        
    } else {
        self.printInProgress = true;
        self.numberPrintFail = 0;
        self.numberPrintSuccess = 0;
        self.filePaths = filePaths;
        [self printFile:0];
    }
}

/*
 * Handle when [UIPrintInteractionController canPrintURL:fileURL] return false
 * support to print html, htm and txt, csv, log files
 */
-(UIPrintFormatter*) generatePrintFormater: (NSURL*) fileURL {
    NSString* fileExtension = [fileURL pathExtension];

    if ([fileExtension isEqualToString:@"html"] || [fileExtension isEqualToString:@"htm"]) {
        NSString* webContent = [NSString stringWithContentsOfFile: fileURL.path
                                                         encoding: NSUTF8StringEncoding
                                                            error: NULL];
        
        UIMarkupTextPrintFormatter* htmlFormatter = [[UIMarkupTextPrintFormatter alloc]
                         initWithMarkupText:webContent];
        
        
        // iOS 10.0
        htmlFormatter.perPageContentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0);
        return htmlFormatter;
    } else if ([fileExtension isEqualToString:@"txt"] ||
               [fileExtension isEqualToString:@"csv"] ||
               [fileExtension isEqualToString:@"log"] ) {
        NSString* txtContent = [NSString stringWithContentsOfFile: fileURL.path
                                                         encoding: NSUTF8StringEncoding
                                                            error: NULL];

        UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc]
                                                     initWithText: txtContent];
        textFormatter.perPageContentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0);
        return textFormatter;
    } else {
        return nil;
    }
}

/*
 * fileIndex: order of file to print in array filePaths
 *
 */
-(void) printFile: (int)fileIndex
{
    if (!self.selectedPrinter) {
        [self raiseError: 100];
        return;
    }
    
    //Reach end of the priting queue
    if (fileIndex == self.filePaths.count) {
        
        NSLock *theLock=[NSLock new];
        [theLock lock];
        self.printInProgress = false;
        self.filePaths = nil;
        [theLock unlock];
        
        [self.silentPrintDelegate onPrintBatchComplete:self.numberPrintSuccess
                                               andFail:self.numberPrintFail];
        return;
    }
    
    
    UIPrintFormatter* printFormatter = nil;
    
    NSString* filePath = self.filePaths[fileIndex];
    NSURL* fileURL = [NSURL fileURLWithPath: filePath];
    if (![UIPrintInteractionController canPrintURL:fileURL]) {
        printFormatter = [self generatePrintFormater:fileURL];
        if (!printFormatter) {
            [self raiseError:200];
            self.numberPrintFail += 1;
            //Move next file
            dispatch_async(dispatch_get_main_queue(), ^{
                [self printFile:fileIndex + 1];
            });
            return;
        }
    }
    
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = [fileURL lastPathComponent];
    
    
    UIPrintInteractionController* printController = [UIPrintInteractionController sharedPrintController];
    printController.printInfo = printInfo;
    
    if (printFormatter) {
        printController.printFormatter = printFormatter;
    } else {
        printController.printingItem = fileURL;
    }
    
    
    
    if (self.silentPrintDelegate && [(id)self.silentPrintDelegate respondsToSelector:@selector(tryToContactPrinter:)]) {
        [self.silentPrintDelegate tryToContactPrinter:self.selectedPrinter];
    }
    
    [self.selectedPrinter contactPrinter:^(BOOL available) {
        if (!available) {
            self.printInProgress = false;
            self.filePaths = @[];  //Reset file array
            [self raiseError: 150];
            return;
        } else {
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
                                      [self.silentPrintDelegate onPrintFileComplete:fileIndex
                                                                            withJob:printInteractionController.printInfo.jobName];
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self printFile:fileIndex + 1];
                                      });
                                  }
                                  
                              }]; //[printController printToPrinter:self.selectedPrinter
            });  //dispatch_async
        }
    }];  //self.selectedPrinter contactPrinter
}
#pragma mark - UIPrintInteractionControllerDelegate
/*
- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray<UIPrintPaper *> *)paperList {
    NSLog(@"%@", paperList);
    return paperList[0];
}
*/
@end
