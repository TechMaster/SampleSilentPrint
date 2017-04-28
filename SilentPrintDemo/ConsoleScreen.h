//
//  ConsoleScreen.h
//  TechmasterApp
//
//  Created by techmaster on 9/7/14.
//  Copyright (c) 2014 Techmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleScreen : UIViewController
- (void) write: (NSString*) string;
- (void) writeln: (NSString*) string;
@end
