//
//  WebViewTextInput.h
//  SilentPrintDemo
//
//  Created by cuong on 6/14/17.
//  Copyright © 2017 techmaster. All rights reserved.
//


//#import "KeyboardBar.h"
#import "CustomKeyBoard.h"
@interface ViewWithKeyboard : UIView

@property (weak, nonatomic) id<CustomKeyboardDelegate> keyboardBarDelegate;
// Override inputAccessoryView to readWrite
- (void) setText: (NSString*) text;

@end
