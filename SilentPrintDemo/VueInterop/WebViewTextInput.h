//
//  WebViewTextInput.h
//  SilentPrintDemo
//
//  Created by cuong on 6/14/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "KeyboardBar.h"
@interface WebViewTextInput : WKWebView

@property (weak, nonatomic) id<KeyboardBarDelegate> keyboardBarDelegate;
// Override inputAccessoryView to readWrite

@end
