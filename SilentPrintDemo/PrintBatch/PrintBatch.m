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
}
@property (weak, nonatomic) IBOutlet UIProgressView *printingProgress;
@property (weak, nonatomic) IBOutlet UILabel *result;

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
    NSLog(@"Error: %@", [error localizedDescription]);
    
    switch (error.code) {
        case 100:
            [self alertError:@"Error" andMessage:[error localizedDescription]];
            break;
        case 200:
            [self alertError:@"Error" andMessage:[error localizedDescription]];
            break;
        default:
            break;
    }
}


-(void)onPrintJobComplete: (NSString*) jobName {
    
    self.result.text = [NSString stringWithFormat:@"Print success : %@", jobName];
    completeJob +=1;
    self.printingProgress.progress = (float) completeJob / (float) totalJob;
}

#pragma mark - UIViewController event
- (void)viewDidLoad {
    [super viewDidLoad];
    self.printingProgress.progress = 0.0;
    self.result.text = @"";
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
    [silentPrint printJobs: jobs];

}


@end
