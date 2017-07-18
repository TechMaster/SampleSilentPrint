//
//  BootLogic.m
//  TechmasterApp
//
//  Created by techmaster on 9/7/14.
//  Copyright (c) 2014 Techmaster. All rights reserved.
//

#import "BootLogic.h"
#import "MainScreen.h"

@implementation BootLogic
+ (void)boot:(UIWindow *)window {
  MainScreen *mainScreen =
      [[MainScreen alloc] initWithStyle:UITableViewStyleGrouped];
  //--------- From this line, please customize your menu data -----------
  NSDictionary *silentPrintDemo = @{
    SECTION : @"Silent Print V2",
    MENU : @[
      @{TITLE : @"Configure Printer", CLASS : @"ConfigurePrinter"},
      @{TITLE : @"Print single file with preview", CLASS : @"PrintSingleItem"},
      @{TITLE : @"Print batch", CLASS : @"PrintBatch"},
      @{TITLE : @"Print batch after batch", CLASS : @"PrintBatchAfterBatch"},
      @{TITLE : @"Print UIView Content", CLASS : @"PrintUIView"}
    ]
  };
    
  NSDictionary *pdfGenerate = @{
    SECTION : @"PDF Generation",
       MENU : @[
      @{TITLE : @"Patient Report Setting", CLASS : @"PatientReport"},
      @{TITLE : @"Report Data In Out", CLASS : @"ReportDataInOut"},
      @{TITLE : @"Doreen Report", CLASS : @"DoreenReport"}
    ]
    };
  
  mainScreen.menu = @[silentPrintDemo, pdfGenerate];
  mainScreen.title = @"Silent Print and Report Generator";
  mainScreen.about = @"This is example app uses Silent Print";
  //--------- End of customization -----------
  UINavigationController *nav =
      [[UINavigationController alloc] initWithRootViewController:mainScreen];

  window.rootViewController = nav;
}
@end
