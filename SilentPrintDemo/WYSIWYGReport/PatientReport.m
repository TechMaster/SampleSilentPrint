//
//  PatientReport.m
//  SilentPrintDemo
//
//  Created by cuong on 6/22/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "PatientReport.h"
#import "PDFGenerator.h"

@interface PatientReport ()
@property (nonatomic, strong) PDFGenerator* generator;
@property (nonatomic, strong) SilentPrint* silentPrint;
@property (nonatomic, strong) PaperConfig* paperConfig;
@end

@implementation PatientReport

- (id) init {
    return [super initWithReportTemplate:@"patient_report"];    
}

- (void) viewDidLoad {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save PDF"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(savePDF)];
    
    self.generator = [PDFGenerator new];
    self.silentPrint = [SilentPrint getSingleton];
    self.silentPrint.silentPrintDelegate = self;
    
    self.paperConfig = [[PaperConfig alloc] initPaperType:PaperTypeLetter
                                              orientation:PaperOrientationPortrait
                                                marginTop:0
                                             marginBottom:0
                                              marginRight:0
                                               marginLeft:0];
}

- (void) savePDF {
    NSString* pdfFile = [NSString stringWithFormat:@"%@tmp.pdf", NSTemporaryDirectory()];
    [self.generator generatePDF: pdfFile
                      ofWebView: self.webView
                withPaperConfig: self.paperConfig
                     onComplete:^(NSString *result, NSError *error) {
                         if (error) {
                             NSLog(@"%@", error);
                         } else {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                             });
                         }
                     }];
}

#pragma mark - SilentPrintDelegate
-(void)onSilentPrintError: (NSError*) error {
    NSLog(@"Error: %@", [error localizedDescription]);
    if (error.code == PRINTER_IS_OFFLINE || error.code == PRINTER_IS_NOT_SELECTED) {
        UIPrinterPickerController *printerPicker = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
        [printerPicker presentAnimated:true completionHandler:^(UIPrinterPickerController * _Nonnull printerPickerController, BOOL userDidSelect, NSError * _Nullable error) {
            if (userDidSelect) {
                self.silentPrint.selectedPrinter = printerPickerController.selectedPrinter;
                [self.silentPrint retryPrint];
            }
        }];
    }
}

@end
