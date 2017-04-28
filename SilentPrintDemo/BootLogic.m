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
      @{TITLE : @"Print single file with preview", CLASS : @"PrintMultipleItems"}
    ]
  };

  NSDictionary *intermediate = @{
    SECTION : @"Intermediate",
    MENU : @[
      @{TITLE : @"Accessory Table", CLASS : @"AccessoryTable"},
    

    ]
  };
  NSDictionary *advanced = @{
    SECTION : @"Advanced",
    MENU : @[
      @{TITLE : @"Custom Draw Cell", CLASS : @"CustomDrawCell"},    
      @{TITLE : @"Basic Lazy Loading", CLASS : @"DemoLazyLoading"}

    ]
  };

  mainScreen.menu = @[ basic, intermediate, advanced ];
  mainScreen.title = @"Silent Print Demo";
  mainScreen.about = @"This is example app uses Silent Print";
  //--------- End of customization -----------
  UINavigationController *nav =
      [[UINavigationController alloc] initWithRootViewController:mainScreen];

  window.rootViewController = nav;
}
@end
