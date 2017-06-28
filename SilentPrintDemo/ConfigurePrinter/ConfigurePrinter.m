//
//  ConfigurePrinter.m
//  SilentPrintDemo
//
//  Created by cuong on 4/27/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "ConfigurePrinter.h"


@interface ConfigurePrinter ()
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedPrinter;
@property (weak, nonatomic) SilentPrint* silentPrint;
@end

@implementation ConfigurePrinter


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.silentPrint = [SilentPrint getSingleton];
    self.silentPrint.silentPrintDelegate = self;
    if (self.silentPrint.selectedPrinter) {
        self.lblSelectedPrinter.text = self.silentPrint.selectedPrinter.displayName;
    }
    
}


-(void)onSilentPrintError: (NSError*) error {
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (IBAction)onConfigurePrint:(UIButton*)sender {
    
    [self.silentPrint configureSilentPrint:sender.frame
                                    inView:self.view
                       orFromBarButtonitem:nil completion:^{
        self.lblSelectedPrinter.text = self.silentPrint.selectedPrinter.displayName;
        
    }];
}

-(void)onPrintJobCallback: (NSString*) jobName
                withError: (NSUInteger) errorCode {
    
}

@end
