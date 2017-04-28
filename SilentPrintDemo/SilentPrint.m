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
//Raise error to outter application
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



@end
