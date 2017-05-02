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
  NSDictionary *basic = @{
    SECTION : @"Basic",
    MENU : @[
      @{TITLE : @"Configure Printer", CLASS : @"ConfigurePrinter"},
      @{TITLE : @"Print single file with preview", CLASS : @"PrintSingleItem"},
      @{TITLE : @"Print multiple files in batch", CLASS : @"PrintMultipleItems"},
      @{TITLE : @"Print batch", CLASS : @"PrintBatch"},
      @{TITLE : @"Print batch after batch", CLASS : @"PrintBatchAfterBatch"}
    ]
  };

  
  mainScreen.menu = @[basic];
  mainScreen.title = @"Silent Print Demo";
  mainScreen.about = @"This is example app uses Silent Print";
  //--------- End of customization -----------
  UINavigationController *nav =
      [[UINavigationController alloc] initWithRootViewController:mainScreen];

  window.rootViewController = nav;
}
@end
