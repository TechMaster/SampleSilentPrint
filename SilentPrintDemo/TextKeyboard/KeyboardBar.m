//
//  KeyboardBar.m
//  KeyboardInputView
//
//  Created by Brian Mancini on 10/4/14.
//  Copyright (c) 2014 iOSExamples. All rights reserved.
//

#import "KeyboardBar.h"

@implementation KeyboardBar

- (id)initWithDelegate:(id<KeyboardBarDelegate>)delegate {
    self = [self init];
    self.delegate = delegate;
    return self;
}

- (id)init {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,0, CGRectGetWidth(screen), 120);
    self = [self initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
        
        //Draw text and button
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, frame.size.width - 70, frame.size.height - 10)];
        self.textView.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f];
        [self.textView setFont:[UIFont systemFontOfSize:18]];
        self.textView.delegate = self; //
        [self addSubview:self.textView];
        
        self.actionButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 60, 5, 55, frame.size.height - 10)];
        self.actionButton.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        self.actionButton.layer.cornerRadius = 2.0;
        self.actionButton.layer.borderWidth = 1.0;
        self.actionButton.layer.borderColor = [[UIColor colorWithWhite:0.45 alpha:1.0f] CGColor];
        [self.actionButton setTitle:@"Save" forState:UIControlStateNormal];
        [self.actionButton addTarget:self action:@selector(didTouchAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.actionButton];
        
    }
    return self;
}

- (void) didTouchAction
{
    [self.delegate keyboardBar:self sendText:self.textView.text];
}

- (void) setText: (NSString*) text {
    self.textView.text = text;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {    
    self.hidden = true;
}

@end
