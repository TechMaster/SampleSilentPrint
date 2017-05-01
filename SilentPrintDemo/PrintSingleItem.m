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

@end

@implementation PrintSingleItem


-(void)onSilentPrintError: (NSError*) error {
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (IBAction)onPrint:(UIButton *)sender {
    SilentPrint* silentPrint = [SilentPrint getSingleton];
    silentPrint.silentPrintDelegate = self;
    [silentPrint printFile: [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"]
                    silent: [self.switchSilentPrint isOn]
                onComplete:^{
         
                }];
}


@end
