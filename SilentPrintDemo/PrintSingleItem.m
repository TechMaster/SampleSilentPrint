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

@end

@implementation PrintSingleItem
- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = true;
    [self.activityIndicator stopAnimating];
    self.result.text = @"";
}

-(void)onSilentPrintError: (NSError*) error {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = true;
    self.result.text = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
}


-(void)tryToContactPrinter:(UIPrinter *)printer {
    self.result.text = [NSString stringWithFormat:@"Try to connect to printer %@", printer.displayName];
}
- (IBAction)onPrint:(UIButton *)sender {
    self.activityIndicator.hidden = false;
    [self.activityIndicator startAnimating];
    self.result.text = @"";

    SilentPrint* silentPrint = [SilentPrint getSingleton];
    silentPrint.silentPrintDelegate = self;
    [silentPrint printFile: [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"]
                    silent: [self.switchSilentPrint isOn]
                onComplete:^{
                    [self.activityIndicator stopAnimating];
                    self.activityIndicator.hidden = true;
                     self.result.text = @"Printing done";
                }];
}


@end
