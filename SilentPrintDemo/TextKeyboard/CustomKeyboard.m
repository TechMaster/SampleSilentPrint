//
//  CustomKeyboard.mUIS//  SilentPrintDemo
//
//  Created by cuong on 6/29/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "CustomKeyboard.h"

@interface CustomKeyBoard()
{
    CGFloat height;
    CGFloat buttonWidth;
    CGFloat margin;
}
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *btnSave;
@property (nonatomic, strong) UIButton *btnClose;
@end


@implementation CustomKeyBoard


- (instancetype)init {
    CGRect screen = [[UIScreen mainScreen] bounds];
    height = 120;
    buttonWidth = 70;
    margin = 5;

    self = [self initWithFrame:CGRectMake(0, 0, screen.size.width, height)];
    self.backgroundColor = [UIColor lightGrayColor];
    
    self.textView = [UITextView new];
    [self.textView setFont:[UIFont systemFontOfSize:20]];
    
    self.btnSave = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.btnSave setTitle:@"Save" forState:UIControlStateNormal];
    
    self.btnSave.backgroundColor = [UIColor grayColor];
    [self.btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.btnSave addTarget:self
                     action:@selector(saveAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    self.btnClose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnClose.backgroundColor = [UIColor grayColor];
    [self.btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnClose setTitle:@"Close" forState:UIControlStateNormal];
    
    [self.btnClose addTarget:self
                      action:@selector(closeKeyboard:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    self.textView.delegate = self;
    
    [self addSubview:self.textView];
    [self addSubview:self.btnSave];
    [self addSubview:self.btnClose];
    
    //Add button to clear content of self.textView
    UIBarButtonItem* clearButton =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"eraser"] style:UIBarButtonItemStylePlain target:self action:@selector(clearText)];
    
    UIBarButtonItemGroup* buttonGroup = [[UIBarButtonItemGroup alloc] initWithBarButtonItems:@[clearButton] representativeItem:nil];
    self.textView.inputAssistantItem.trailingBarButtonGroups = @[buttonGroup];
    
    
    
    return self;
}
- (void)layoutSubviews {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0, 0, screen.size.width, height);
    self.frame = frame;
    
    self.textView.frame = CGRectMake(margin,
                                     margin,
                                     frame.size.width - buttonWidth - 3 * margin,
                                     height - margin * 2);
    
    self.btnSave.frame = CGRectMake(frame.size.width - buttonWidth - 1 * margin ,
                                    margin,
                                    buttonWidth,
                                    (height - margin * 3) * 0.5);
    
    self.btnClose.frame = CGRectMake(frame.size.width - buttonWidth - 1 * margin ,
                                     2* margin + (height - margin * 3) * 0.5,
                                     buttonWidth,
                                     (height - margin * 3) * 0.5);

    
}


//user swipes down on text view, then close it
-(IBAction) closeKeyboard:(UIButton *)sender {
    [self.textView resignFirstResponder];
    [self.delegate onKeyboardClose:self];
}
- (IBAction)saveAction:(UIButton *)sender {
    [self.delegate onKeyboard:self save:self.textView.text];
}

- (void) clearText {
    self.textView.text = @"";
}


- (void) setText: (NSString*) text {
    self.textView.text = text;
}

- (void) focusTextView {
    [self.textView becomeFirstResponder];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.hidden = true;
}


@end
