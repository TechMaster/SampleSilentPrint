//
//  VueInterop.h
//  SilentPrintDemo
//
//  Created by cuong on 6/4/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebViewTextInput.h"

@interface VueInterop : UIViewController <WKScriptMessageHandler, UIImagePickerControllerDelegate>
@property(nonatomic, strong) WebViewTextInput *webView;
@end
