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

@end

@implementation PrintBatchAfterBatch

- (void)viewDidLoad {
    [super viewDidLoad];
    self.printingProgress.progress = 0.0;
    self.activityIndicator.hidden = true;
    [self.activityIndicator stopAnimating];
    self.result.text = @"";
}

#pragma mark - SilentPrintDelegate
/*-(void)alertError: (NSString*) title
       andMessage: (NSString*) message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}*/


-(void)tryToContactPrinter:(UIPrinter *)printer {
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = false;
    self.result.text = [NSString stringWithFormat:@"Try to connect to printer %@", printer.displayName];
}

-(void)onSilentPrintError: (NSError*) error {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = true;
    self.result.text = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
}

-(void)onPrintFileComplete: (int) fileIndex withJob: (NSString*) jobName {
    SilentPrint* silentPrint = [SilentPrint getSingleton];
    self.printingProgress.progress = (float) (fileIndex + 1) / (float)silentPrint.filePaths.count;
    
}

-(void) onPrintBatchComplete:(int)success andFail:(int)fail {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = true;

    NSLog(@"Success : %d. - Fail: %d", success, fail);
    self.result.text = [NSString stringWithFormat:@"Success : %d - Fail: %d", success, fail];
}


#pragma mark - Print logic
- (IBAction)printManyBatches:(id)sender {
    SilentPrint* silentPrint = [SilentPrint getSingleton];
    silentPrint.silentPrintDelegate = self;
    
    
    
    NSArray *filePaths1 = @[
                           [[NSBundle mainBundle] pathForResource:@"koi" ofType:@"jpg"],
                           @"NoExistFile.jpg",
                           [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"],
                           [[NSBundle mainBundle] pathForResource:@"1" ofType:@"pdf"],
                           [[NSBundle mainBundle] pathForResource:@"3" ofType:@"html"]
                           ];
    
    
    NSArray *filePaths2 = @[
                            [[NSBundle mainBundle] pathForResource:@"4" ofType:@"html"],
                            [[NSBundle mainBundle] pathForResource:@"5" ofType:@"html"],
                            [[NSBundle mainBundle] pathForResource:@"6" ofType:@"html"],
                            [[NSBundle mainBundle] pathForResource:@"7" ofType:@"html"]
                            ];
    self.printingProgress.progress = 0.0;
    
    [silentPrint printBatch: filePaths1];
    [silentPrint printBatch: filePaths2];

}


@end
