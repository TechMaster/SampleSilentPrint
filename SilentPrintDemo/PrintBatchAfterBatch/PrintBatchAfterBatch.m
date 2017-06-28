//
//  PrintBatchAfterBatch.m
//  SilentPrintDemo
//
//  Created by cuong on 5/2/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "PrintBatchAfterBatch.h"

@interface PrintBatchAfterBatch ()
{
    NSUInteger totalJob;
    NSUInteger completeJob;
    NSUInteger failedJob;
}
@property (weak, nonatomic) IBOutlet UIButton *btnPrint;
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
        
        [self.silentPrint configureSilentPrint:self.btnPrint.frame
                                        inView:self.view
                           orFromBarButtonitem:nil completion:^{                               
                               self.result.text = self.silentPrint.selectedPrinter.displayName;
                               [self.silentPrint retryPrint];
        }];
    }
}

- (void) onPrintJobCallback:(NSString *)jobName
                  withError:(NSUInteger)errorCode {
    if (errorCode == PRINT_SUCCESS) {
        completeJob += 1;
    } else {
        failedJob += 1;
    }
    if (totalJob ==  completeJob + failedJob) {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = true;
    }
    
    self.result.text = [NSString stringWithFormat:@"Print jobs: %lu - Complete jobs: %lu - Failed jobs: %lu", (unsigned long)totalJob, (unsigned long)completeJob, (unsigned long) failedJob];
    self.printingProgress.progress = (float) (completeJob + failedJob) / (float) totalJob;
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
    
    NSMutableArray* jobs = [NSMutableArray new];
    for (NSString* item in filePaths1) {
        PrintJob* job = [[PrintJob alloc] init:item withShow:FALSE];
        job.name = [item lastPathComponent];
        [jobs addObject:job];
    }
    
    NSArray *filePaths2 = @[
                            [[NSBundle mainBundle] pathForResource:@"4" ofType:@"html"],
                            [[NSBundle mainBundle] pathForResource:@"log1" ofType:@"log"],
                            [[NSBundle mainBundle] pathForResource:@"log2" ofType:@"csv"]  
                            ];
    
    
    NSMutableArray* jobs2 = [NSMutableArray new];
    for (NSString* item in filePaths2) {
        PrintJob* job = [[PrintJob alloc] init:item withShow:FALSE];
        job.name = [item lastPathComponent];
        [jobs2 addObject:job];
    }
    
    totalJob = jobs.count + jobs2.count;
    completeJob = 0;
    failedJob = 0;
    self.printingProgress.progress = 0.0;
    [self.silentPrint printJobs: jobs];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.silentPrint printJobs: jobs2];
    });

}


@end
