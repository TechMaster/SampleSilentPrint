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

@end

@implementation ConfigurePrinter
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    SilentPrint* silentPrint = [SilentPrint getSingleton];
    if (silentPrint.selectedPrinter) {
        self.lblSelectedPrinter.text = silentPrint.selectedPrinter.displayName;
    }
    
}


-(void)onSilentPrintError: (NSError*) error {
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (IBAction)onConfigurePrint:(UIButton*)sender {
    SilentPrint* silentPrint = [SilentPrint getSingleton];
    silentPrint.silentPrintDelegate = self;
    
    [silentPrint configureSilentPrint:sender.frame
                               inView:self.view
                           completion:^{
                               //NSLog(@"%@",silentPrint.selectedPrinter.displayName);
                               self.lblSelectedPrinter.text = silentPrint.selectedPrinter.displayName;
        
    }];
}

@end
