//
//  PrintMultipleItems.m
//  SilentPrintDemo
//
//  Created by cuong on 4/27/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "PrintMultipleItems.h"

@interface PrintMultipleItems ()
@property (weak, nonatomic) IBOutlet UILabel *selectedPrinter;

@end

@implementation PrintMultipleItems

- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
}

-(void)onSilentPrintError: (NSError*) error {
    NSLog(@"Error: %@", [error localizedDescription]);
}

/*
 https://developer.apple.com/library/content/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/Printing/Printing.html
 
 http://nshipster.com/uiprintinteractioncontroller/
 */

- (IBAction)onPrint:(UIButton *)sender {
    SilentPrint* silentPrint = [SilentPrint getSingleton];
    silentPrint.silentPrintDelegate = self;
    
    if (!silentPrint.selectedPrinter) {
        [silentPrint configureSilentPrint:sender.frame
                                   inView:self.view
                               completion:^{
                                   self.selectedPrinter.text = silentPrint.selectedPrinter.displayName;
                               }];
        
    } else {
        UIPrintInteractionController* printController = [UIPrintInteractionController sharedPrintController];
        printController.delegate = self;
        
        NSURL* file1URL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"1" ofType:@"pdf"]];
        NSURL* file2URL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"]];
        
        
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"Print mutiple documents";
        printInfo.duplex = false;
        
        printController.printInfo = printInfo;
        
        printController.printingItems = @[file1URL, file2URL];
        
        [printController printToPrinter:silentPrint.selectedPrinter
                      completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"%@", error);
                          }
                          if (completed) {
                              NSLog(@"IN XONG ROI");
                          }
                          
                      }];
        
    }
    
}

#pragma mark - UIPrintInteractionControllerDelegate
- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"Start printing %@", printInteractionController.printInfo);
}


- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"Finish printing %@", printInteractionController.printInfo);
}
@end
