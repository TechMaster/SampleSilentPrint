//
//  PrintBatch.m
//  SilentPrintDemo
//
//  Created by cuong on 4/28/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "PrintBatch.h"

@interface PrintBatch ()
{
    NSUInteger totalJob;
    NSUInteger completeJob;
    NSUInteger failedJob;
}
@property (weak, nonatomic) IBOutlet UIButton *btnPrint;
@property (weak, nonatomic) IBOutlet UIProgressView *printingProgress;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) SilentPrint* silentPrint;
@end

@implementation PrintBatch

#pragma mark - SilentPrintDelegate
-(void)alertError: (NSString*) title
       andMessage: (NSString*) message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)onSilentPrintError: (NSError*) error {
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
    self.result.text = [NSString stringWithFormat:@"Print jobs: %lu - Complete jobs: %lu - Failed jobs: %lu", (unsigned long)totalJob, (unsigned long)completeJob, (unsigned long) failedJob];
    self.printingProgress.progress = (float) completeJob / (float) totalJob;
}

#pragma mark - UIViewController event
- (void)viewDidLoad {
    [super viewDidLoad];
    self.printingProgress.progress = 0.0;
    self.result.text = @"";
    
    self.silentPrint = [SilentPrint getSingleton];
    self.silentPrint.silentPrintDelegate = self;
}

#pragma mark - Print logic
- (IBAction)printBatch:(id)sender {
    SilentPrint* silentPrint = [SilentPrint getSingleton];
    silentPrint.silentPrintDelegate = self;
    
    
    
    NSArray *filePaths = @[
                           [[NSBundle mainBundle] pathForResource:@"koi" ofType:@"jpg"],
                           @"NoExistFile.jpg",
                           [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"],
                           [[NSBundle mainBundle] pathForResource:@"1" ofType:@"pdf"],
                           [[NSBundle mainBundle] pathForResource:@"3" ofType:@"html"]
                           ];
    
    self.printingProgress.progress = 0.0;
    
    NSMutableArray* jobs = [NSMutableArray new];
    for (NSString* item in filePaths) {
        PrintJob* job = [[PrintJob alloc] init:item withShow:FALSE];
        job.name = [item lastPathComponent];
        [jobs addObject:job];
    }
    UIImage *image = [UIImage imageNamed:@"01.jpg"];
    PrintJob* jobView = [[PrintJob alloc] init:image withShow:FALSE];
    jobView.name = @"an image";
    [jobs addObject:jobView];
    
    totalJob = jobs.count;
    completeJob = 0;
    failedJob = 0;
    self.printingProgress.progress = 0.0;
    self.result.text = @"";
    
    [silentPrint printJobs: jobs];
    
}


@end
