//
//  MustacheBasicDemo.m
//  SilentPrintDemo
//
//  Created by cuong on 5/11/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "MustacheBasicDemo.h"
#import <WebKit/WebKit.h>
#import "PDFGenerator.h"


@interface MustacheBasicDemo ()
@property (nonatomic, strong) PDFGenerator* generator;
@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) SilentPrint* silentPrint;
@property (nonatomic, strong) PaperConfig* paperConfig;
@end

@implementation MustacheBasicDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview: self.webView];
    
    UIBarButtonItem* generateA4PDF = [[UIBarButtonItem alloc] initWithTitle:@"A4" style:UIBarButtonItemStylePlain target:self action:@selector(generateA4PDF)];
    
    UIBarButtonItem* generateLetterPDF = [[UIBarButtonItem alloc] initWithTitle:@"Letter" style:UIBarButtonItemStylePlain target:self action:@selector(generateLetterPDF)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItems = @[generateA4PDF, generateLetterPDF];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Print" style:UIBarButtonItemStylePlain target:self action:@selector(printDocument)];
    
    self.generator = [PDFGenerator new];
    self.silentPrint = [SilentPrint getSingleton];
    self.silentPrint.silentPrintDelegate = self;
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

- (void) generateA4PDF {
    self.paperConfig = [PaperConfig new];
    self.paperConfig.paperType = PaperTypeA4;
    self.paperConfig.paperOrientation = PaperOrientationPortrait;
    [self generatePDF];
}

- (void) generateLetterPDF {
    self.paperConfig = [PaperConfig new];
    self.paperConfig.paperType = PaperTypeLetter;
    self.paperConfig.paperOrientation = PaperOrientationPortrait;
    [self generatePDF];
}

- (void) generatePDF {
    NSDictionary* data = @{@"name": @"Arthur"};
    [self.generator generateHTML: data
                 withPaperConfig: self.paperConfig
                    fromResource: @"PortraitReport"
                          bundle: nil
                      onComplete: ^(NSString *result, NSError *error) {
                          if (error) {
                              NSLog(@"%@", error);
                          } else {
                              NSString *path = [[NSBundle mainBundle] bundlePath];
                              NSURL *baseURL = [NSURL fileURLWithPath:path];
                              [self.webView loadHTMLString:result baseURL: baseURL];
                          }
                      }];

}


- (void) printDocument {
    NSString* pdfFile = [NSString stringWithFormat:@"%@tmp.pdf", NSTemporaryDirectory()];
    [self.generator generatePDF: pdfFile
                      ofWebView: self.webView
                withPaperConfig: self.paperConfig
                     onComplete:^(NSString *result, NSError *error) {
                         if (error) {
                             NSLog(@"%@", error);
                         } else {
                             NSLog(@"PDF: %@", result);
                             [self.silentPrint printFile: result
                                                inSilent: false];
                         }
                       }];
}

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
