//
//  CustomKeyBoard.m
//  SilentPrintDemo
//
//  Created by cuong on 6/22/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "CustomKeyBoard.h"
@interface CustomKeyBoard()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;

@end
@implementation CustomKeyBoard


- (id)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomKeyBoard" owner:self options:nil] firstObject];

    self.textView.delegate = self;
    /*//Swipe down to close text view
    UISwipeGestureRecognizer* swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown)];
    
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.textView addGestureRecognizer: swipeRecognizer];*/

    UIBarButtonItem* clearButton = /*[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearText)]; */
    
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"eraser"] style:UIBarButtonItemStylePlain target:self action:@selector(clearText)];
    
    
    UIBarButtonItemGroup* buttonGroup = [[UIBarButtonItemGroup alloc] initWithBarButtonItems:@[clearButton] representativeItem:nil];
    self.textView.inputAssistantItem.trailingBarButtonGroups = @[buttonGroup];
    return self;
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
