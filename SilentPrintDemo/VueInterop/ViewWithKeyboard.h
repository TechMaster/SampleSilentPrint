//
//  WebViewTextInput.h
//  SilentPrintDemo
//
//  Created by cuong on 6/14/17.
//  Copyright © 2017 techmaster. All rights reserved.
//


#import "KeyboardBar.h"
@interface ViewWithKeyboard : UIView

@property (weak, nonatomic) id<KeyboardBarDelegate> keyboardBarDelegate;
// Override inputAccessoryView to readWrite
- (void) setText: (NSString*) text;
@end
