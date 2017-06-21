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
        _inputAccessoryView = [[KeyboardBar alloc] initWithDelegate:self.keyboardBarDelegate];
    }
    return _inputAccessoryView;
}

- (void) setText: (NSString*) text {
    [(KeyboardBar*) self.inputAccessoryView setText:text];
}

@end