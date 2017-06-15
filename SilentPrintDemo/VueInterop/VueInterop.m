//
//  VueInterop.m
//  SilentPrintDemo
//
//  Created by cuong on 6/4/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "VueInterop.h"
#import "UIImage+Utils.h"
#import "ViewWithKeyboard.h"

@interface VueInterop ()
@property (nonatomic, strong) NSString* selectID;
@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) ViewWithKeyboard* view;
@end

@implementation VueInterop
@dynamic view;

- (void) loadView {
    self.view = [[ViewWithKeyboard alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"letter_portrait_vue"
                                                     ofType:@"html"];
    
    NSString* htmlString = [NSString stringWithContentsOfFile: path
                                                     encoding: NSUTF8StringEncoding
                                                        error: nil];
    
    WKWebViewConfiguration *theConfiguration = [WKWebViewConfiguration new];
    
    [theConfiguration.userContentController addScriptMessageHandler:self
                                                               name:@"interOp"];
    
    self.webView = [[WKWebView alloc] initWithFrame: self.view.bounds
                                          configuration:theConfiguration];
   
    
    self.view.keyboardBarDelegate = self;
    
    [self.view addSubview:self.webView];
    
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
    
}
- (void) showKeyboard {
    if (![self.view isFirstResponder]) {
        self.view.inputAccessoryView.hidden = false;
        [self.view becomeFirstResponder];
    } else {
        [self.view resignFirstResponder];
    }
    
}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"w = %f, h = %f", size.width, size.height);
    self.view.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *sentData = (NSDictionary*)message.body;
    NSString* action = sentData[@"action"];
    self.selectID = sentData[@"id"];  //Store element ID in web report
    
    
    if ([action isEqual: @"openCameraRoll"]) {
        [self openCameraRoll];

    } else if ([action isEqual:@"enterText"]) {
        [self showKeyboard];
    }
        /*
    long aCount = [sentData[@"count"] integerValue];
    aCount++;
    
    
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"count": @555, @"data": @"World is wild and fun", @"gender": @true}
                                                       options:(NSJSONWritingOptions) (NSJSONWritingPrettyPrinted)
                                                         error:&error];
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
   
    NSLog(@"%@", jsonString);
    
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"receiveJSON(%@)", jsonString]
                   completionHandler:nil];*/
}

-(void) openCameraRoll {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage* selectedImage = info[@"UIImagePickerControllerOriginalImage"];
    NSString* resizedImagePath = [selectedImage scaleTo:600];
   
    
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"changePhoto('%@', '%@')", resizedImagePath, self.selectID]
                   completionHandler:nil];
    
    
    
    [picker dismissViewControllerAnimated:true completion:^{
        
    }];
    
}

#pragma mark - KeyboardBarDelegate
- (void)keyboardBar:(KeyboardBar *)keyboardBar sendText:(NSString *)text {
    NSLog(@"%@", text);
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"Vue.set(app, '%@', '%@')", self.selectID , text]
                   completionHandler:nil];
}
@end
