//
//  WebViewTextInput.m
//  SilentPrintDemo
//
//  Created by cuong on 6/14/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "ViewWithKeyboard.h"


@interface ViewWithKeyboard()
// Override inputAccessoryView to readWrite
@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;
@end

@implementation ViewWithKeyboard

// Override canBecomeFirstResponder
// to allow this view to be a responder
- (bool) canBecomeFirstResponder {
    return true;
}

// Override inputAccessoryView to use
// an instance of KeyboardBar
- (UIView *)inputAccessoryView {
    if(!_inputAccessoryView) {
       // _inputAccessoryView = [[KeyboardBar alloc] initWithDelegate:self.keyboardBarDelegate];
        
        CustomKeyBoard* customKeyboard = [CustomKeyBoard new];
        customKeyboard.delegate = self.keyboardBarDelegate;
        _inputAccessoryView = customKeyboard;
        
    }
    return _inputAccessoryView;
}

- (void) setText: (NSString*) text{
    CustomKeyBoard* customKeyboard = (CustomKeyBoard*) self.inputAccessoryView;
    [customKeyboard setText:text];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [customKeyboard focusTextView];
    });
}


@end
