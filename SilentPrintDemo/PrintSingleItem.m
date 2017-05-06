//
//  PrintSingleItem.m
//  SilentPrintDemo
//
//  Created by cuong on 4/28/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "PrintSingleItem.h"

@interface PrintSingleItem ()
@property (weak, nonatomic) IBOutlet UISwitch *switchSilentPrint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) SilentPrint* silentPrint;
@end

@implementation PrintSingleItem


- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = true;
    [self.activityIndicator stopAnimating];
    self.result.text = @"";
    
    self.silentPrint = [SilentPrint getSingleton];
    self.silentPrint.silentPrintDelegate = self;
    
}

-(void)onSilentPrintError: (NSError*) error {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = true;
    self.result.text = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
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


-(void)tryToContactPrinter:(UIPrinter *)printer {
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = false;
    self.result.text = [NSString stringWithFormat:@"Try to connect to printer %@", printer.displayName];
}
- (IBAction)onPrint:(UIButton *)sender {
    self.activityIndicator.hidden = false;
    [self.activityIndicator startAnimating];
    self.result.text = @"";

    
    [self.silentPrint printFile: [self randomeFileToPrint]
                       inSilent: [self.switchSilentPrint isOn]];
    
}

-(void)onPrintFileComplete: (int) fileIndex withJob: (NSString*) jobName {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = true;
    self.result.text = [NSString stringWithFormat:@"Print success : %@", jobName];
}


- (NSString*) randomeFileToPrint {
    NSArray* fileArrays = @[@"1.pdf", @"2.jpg", @"3.html", @"4.html", @"5.html", @"6.hml", @"7.html", @"8.html", @"log1.log", @"log2.csv"];
    
    int fileIndex = arc4random() % fileArrays.count;
    NSString* file = fileArrays[fileIndex];    
    NSArray* fileComponents = [file componentsSeparatedByString:@"."];
    return [[NSBundle mainBundle] pathForResource: fileComponents[0]
                                           ofType: fileComponents[1]];
}


@end
