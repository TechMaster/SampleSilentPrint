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
    });
    return _sharedInstance;
}
/* Raise error to outter application
 100: printer is not selected
 200: cannot print file URL
 */
-(void)raiseError: (NSInteger) errorCode
      withMessage: (NSString*) message {
    //make sure delegate is not nil
    if (self.silentPrintDelegate) {
        NSError* error = [NSError errorWithDomain: @"SilentPrint"
                                             code: errorCode
                                         userInfo: @{NSLocalizedDescriptionKey: message}
                          ];
        [self.silentPrintDelegate onSilentPrintError:error];
    }
    
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
                         [self raiseError: 100
                              withMessage: @"Printer is not selected"];
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
        [self raiseError: 100
             withMessage: @"Printer is not selected"];
    }
    
    UIMarkupTextPrintFormatter* htmlFormatter = nil;
    
    NSURL* fileURL = [NSURL fileURLWithPath: filePath];
    if (![UIPrintInteractionController canPrintURL:fileURL]) {
        NSString* fileExtension = [fileURL pathExtension];
        if ([fileExtension isEqualToString:@"html"] || [fileExtension isEqualToString:@"htm"]) {
            NSString* webContent = [NSString stringWithContentsOfFile:filePath
                                                             encoding:NSUTF8StringEncoding
                                                                error:NULL];
            
            htmlFormatter = [[UIMarkupTextPrintFormatter alloc]
                             initWithMarkupText:webContent];
            htmlFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
            
            // iOS 10.0
            //    htmlFormatter.perPageContentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0);
            
        } else {
            [self raiseError:200
                 withMessage:[NSString stringWithFormat:@"%@ cannot print", filePath]];
            return;
        }
    }
    
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = [fileURL lastPathComponent];
    //printInfo.duplex = self.selectedPrinter.supportsDuplex;
    
    
    UIPrintInteractionController* printController = [UIPrintInteractionController sharedPrintController];
    printController.printInfo = printInfo;
    
    if (htmlFormatter) {
        printController.printFormatter = htmlFormatter;
    } else {
        printController.printingItem = fileURL;
    }
    
    
    if (silent) {
        [printController printToPrinter:self.selectedPrinter
                      completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
                          if (error) {
                              [self.silentPrintDelegate onSilentPrintError:error];
                          }
                          if (completed) {
                              NSLog(@"%@ IN XONG ROI", printInteractionController.printInfo.jobName);
                              if (complete) {
                                  complete();
                              }
                          }
                          
                      }];
    } else {
         [printController presentAnimated:true completionHandler: nil];
    }
    
    
}

-(void) printBatch:(NSArray *)filePaths
{
    self.filePaths = filePaths;
    [self printFile:0];
}

-(void) printFile: (int)fileIndex
{
    if (fileIndex == self.filePaths.count) {
        return;
    }
    
    if (!self.selectedPrinter) {
        [self raiseError: 100
             withMessage: @"Printer is not selected"];
    }
    
    
    UIMarkupTextPrintFormatter* htmlFormatter = nil;
    
    NSString* filePath = self.filePaths[fileIndex];
    NSURL* fileURL = [NSURL fileURLWithPath: filePath];
    if (![UIPrintInteractionController canPrintURL:fileURL]) {
        NSString* fileExtension = [fileURL pathExtension];
        if ([fileExtension isEqualToString:@"html"] || [fileExtension isEqualToString:@"htm"]) {
            NSString* webContent = [NSString stringWithContentsOfFile:filePath
                                                             encoding:NSUTF8StringEncoding
                                                                error:NULL];
            
            htmlFormatter = [[UIMarkupTextPrintFormatter alloc]
                             initWithMarkupText:webContent];
            
            
            // iOS 10.0
            htmlFormatter.perPageContentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0);
            
        } else {
            [self raiseError:200
                 withMessage:[NSString stringWithFormat:@"%@ cannot print", filePath]];
            return;
        }
    }
    
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = [fileURL lastPathComponent];
    //printInfo.duplex = self.selectedPrinter.supportsDuplex;
    
    
    UIPrintInteractionController* printController = [UIPrintInteractionController sharedPrintController];
    printController.printInfo = printInfo;
    
    if (htmlFormatter) {
        printController.printFormatter = htmlFormatter;
    } else {
        printController.printingItem = fileURL;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [printController printToPrinter:self.selectedPrinter
                      completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
                          if (error) {
                              [self.silentPrintDelegate onSilentPrintError:error];
                          }
                          if (completed) {
                              // Gọi hàm callback
                              [self.silentPrintDelegate onPrintFileComplete:fileIndex
                                                                    withJob:printInteractionController.printInfo.jobName];
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [self printFile:fileIndex + 1];
                              });
                          }
                          
                      }];
    });
    
}

@end
