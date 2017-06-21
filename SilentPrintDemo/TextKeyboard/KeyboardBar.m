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
    CGRect frame = CGRectMake(0,0, CGRectGetWidth(screen), 240);
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
        [self.textView setFont:[UIFont systemFontOfSize:20]];
        self.textView.delegate = self; //
        [self addSubview:self.textView];
        
        //self.btnSave = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 60, 5, 55, frame.size.height - 10)];
        self.btnSave = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 60, 5, 55, (frame.size.height - 20) * 0.5)];
        self.btnSave.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        self.btnSave.layer.cornerRadius = 2.0;
        self.btnSave.layer.borderWidth = 1.0;
        self.btnSave.layer.borderColor = [[UIColor colorWithWhite:0.45 alpha:1.0f] CGColor];
        [self.btnSave setTitle:@"Save" forState:UIControlStateNormal];
        [self.btnSave addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnClear = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 60, (frame.size.height - 20) * 0.5 + 15, 55, (frame.size.height - 20) * 0.5)];
        self.btnClear.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        self.btnClear.layer.cornerRadius = 2.0;
        self.btnClear.layer.borderWidth = 1.0;
        self.btnClear.layer.borderColor = [[UIColor colorWithWhite:0.45 alpha:1.0f] CGColor];
        [self.btnClear setTitle:@"Clear" forState:UIControlStateNormal];
        [self.btnClear addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.btnSave];
        [self addSubview:self.btnClear];
        
    }
    return self;
}

- (void) saveAction
{
    [self.delegate keyboardBar:self sendText:self.textView.text];
}

- (void) clearAction {
    self.textView.text = @"";
}

- (void) setText: (NSString*) text {
    self.textView.text = text;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {    
    self.hidden = true;
}

@end
