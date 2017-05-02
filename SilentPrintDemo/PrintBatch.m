//
//  PrintBatch.m
//  SilentPrintDemo
//
//  Created by cuong on 4/28/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "PrintBatch.h"

@interface PrintBatch ()
@property (weak, nonatomic) IBOutlet UIProgressView *printingProgress;

@end

@implementation PrintBatch

#pragma mark - 
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


-(void)onPrintFileComplete: (int) fileIndex withJob: (NSString*) jobName {
    SilentPrint* silentPrint = [SilentPrint getSingleton];
    self.printingProgress.progress = (float) (fileIndex + 1) / (float)silentPrint.filePaths.count;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.printingProgress.progress = 0.0;
}

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
    
    [silentPrint printBatch: filePaths];

}


@end
