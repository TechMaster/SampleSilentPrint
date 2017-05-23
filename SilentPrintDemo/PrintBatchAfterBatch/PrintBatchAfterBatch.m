//
//  PrintBatchAfterBatch.m
//  SilentPrintDemo
//
//  Created by cuong on 5/2/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "PrintBatchAfterBatch.h"

@interface PrintBatchAfterBatch ()
@property (weak, nonatomic) IBOutlet UIProgressView *printingProgress;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) SilentPrint* silentPrint;
@end

@implementation PrintBatchAfterBatch

- (void)viewDidLoad {
    [super viewDidLoad];
    self.printingProgress.progress = 0.0;
    self.activityIndicator.hidden = true;
    [self.activityIndicator stopAnimating];
    self.result.text = @"";
    self.silentPrint = [SilentPrint getSingleton];
    self.silentPrint.silentPrintDelegate = self;

}

#pragma mark - SilentPrintDelegate


-(void)tryToContactPrinter:(UIPrinter *)printer {
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = false;
    self.result.text = [NSString stringWithFormat:@"Try to connect to printer %@", printer.displayName];
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

-(void)onPrintFileComplete: (int) fileIndex withJob: (NSString*) jobName {
   
    self.printingProgress.progress = (float) (fileIndex + 1) / (float) self.silentPrint.filePaths.count;
    
}

-(void) onPrintBatchComplete:(int)success andFail:(int)fail {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = true;

    NSLog(@"Success : %d. - Fail: %d", success, fail);
    self.result.text = [NSString stringWithFormat:@"Success : %d - Fail: %d", success, fail];
}


#pragma mark - Print logic
- (IBAction)printManyBatches:(id)sender {
    NSArray *filePaths1 = @[
                           [[NSBundle mainBundle] pathForResource:@"koi" ofType:@"jpg"],
                           @"NoExistFile.jpg",
                           [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"],
                           [[NSBundle mainBundle] pathForResource:@"1" ofType:@"pdf"],
                           [[NSBundle mainBundle] pathForResource:@"3" ofType:@"html"]
                           ];
    
    
    NSArray *filePaths2 = @[
                            [[NSBundle mainBundle] pathForResource:@"4" ofType:@"html"],
                            [[NSBundle mainBundle] pathForResource:@"log1" ofType:@"log"],
                            [[NSBundle mainBundle] pathForResource:@"log2" ofType:@"csv"]  
                            ];
    self.printingProgress.progress = 0.0;
    
    [self.silentPrint printBatch: filePaths1];
    [self.silentPrint printBatch: filePaths2];

}


@end
