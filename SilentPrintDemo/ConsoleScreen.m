//
//  ConsoleScreen.m
//  TechmasterApp
//
//  Created by techmaster on 9/7/14.
//  Copyright (c) 2014 Techmaster. All rights reserved.
//

#import "ConsoleScreen.h"

@interface ConsoleScreen ()
@property (nonatomic, weak) UITextView* console;
@end

@implementation ConsoleScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITextView* console = [[UITextView alloc] initWithFrame:self.view.bounds];
    
    console.backgroundColor = [UIColor blackColor];
    console.textColor = [UIColor greenColor];
    console.font = [UIFont fontWithName:@"Courier" size:16];
    console.editable = false;
    [self.view addSubview:console];
    self.console = console;
}

- (void) write: (NSString*) string
{
    NSMutableString * temp = [NSMutableString stringWithString:self.console.text];
    [temp appendString:string];
    self.console.text = temp;
}
- (void) writeln: (NSString*) string
{
    NSMutableString * temp = [NSMutableString stringWithString:self.console.text];
    [temp appendString:string];
    [temp appendString:@"\n"];
    self.console.text = temp;
}


@end
