//
//  CustomKeyBoard.h
//  SilentPrintDemo
//
//  Created by cuong on 6/22/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomKeyBoard;
@protocol CustomKeyboardDelegate <NSObject>


- (void)onKeyboard:(CustomKeyBoard *)customKeyBoard save:(NSString *)text;

//Handle when user close keyboard
- (void)onKeyboardClose:(CustomKeyBoard *)customKeyBoard;

@end

@interface CustomKeyBoard : UIView <UITextViewDelegate>
@property (weak, nonatomic) id<CustomKeyboardDelegate> delegate;

- (void) setText: (NSString*) text;
- (void) focusTextView;
@end
