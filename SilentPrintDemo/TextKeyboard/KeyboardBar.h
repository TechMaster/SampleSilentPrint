//
//  KeyboardBar.h
//  KeyboardInputView
//
//  Created by Brian Mancini on 10/4/14.
//  Copyright (c) 2014 iOSExamples. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyboardBar;

@protocol KeyboardBarDelegate <NSObject>

- (void)keyboardBar:(KeyboardBar *)keyboardBar sendText:(NSString *)text;

@end

@interface KeyboardBar : UIView <UITextViewDelegate>

- (id)initWithDelegate:(id<KeyboardBarDelegate>)delegate;
- (void) setText: (NSString*) text;

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *btnSave;
@property (strong, nonatomic) UIButton *btnClear;

@property (weak, nonatomic) id<KeyboardBarDelegate> delegate;

@end
