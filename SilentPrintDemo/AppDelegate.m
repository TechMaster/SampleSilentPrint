//
//  AppDelegate.m
//  TechmasterApp
//
//  Created by techmaster on 9/7/14.
//  Copyright (c) 2014 Techmaster. All rights reserved.
//

#import "AppDelegate.h"
#import "BootLogic.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Cuong: Just include this line in AppDelegate
    [BootLogic boot:self.window];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
