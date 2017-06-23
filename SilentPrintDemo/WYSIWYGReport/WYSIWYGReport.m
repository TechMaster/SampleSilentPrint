//
//  VueInterop.m
//  SilentPrintDemo
//
//  Created by cuong on 6/4/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "WYSIWYGReport.h"
#import "UIImage+Utils.h"
#import "ViewWithKeyboard.h"
#import "HTMLConverter.h"

@interface WYSIWYGReport()
@property (nonatomic, strong) NSString* selectID;

@property (nonatomic, strong) ViewWithKeyboard* view;
@property (nonatomic, strong) HTMLConverter* htmlConverter;
@end

@implementation WYSIWYGReport
@dynamic view;

#pragma mark - public methods
-(id) initWithReportTemplate: (NSString*) report {
    self = [super init];
    if (self) {
        _reportTemplate = report;
    }
    return self;
}

-(void) applyJSONDataToReport: (NSString*) json
            completionHandler: (void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler
{
    [self.webView evaluateJavaScript: [NSString stringWithFormat: @"setData(%@);", json]
                   completionHandler: completionHandler];
}


#pragma mark - UIViewController methods
- (void) loadView {
    self.view = [[ViewWithKeyboard alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:self.reportTemplate
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
    
    self.htmlConverter = [HTMLConverter new];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.webView evaluateJavaScript:@"setMode('edit');"
                   completionHandler: nil];

}

- (BOOL) becomeFirstResponder {
    return true;
}


/*
 Handle event when iPad orientation changes
 */
-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.view.frame = CGRectMake(0, 0, size.width, size.height);
    self.webView.frame = self.view.bounds;
    
    if (![self.selectID isEqualToString:@""]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.webView evaluateJavaScript:[NSString stringWithFormat:@"scrollToSelectedElement('%@')", self.selectID]
                           completionHandler:nil];
        });
    }
}


#pragma mark
- (void) setScaleLevel: (float) scale {
    NSString* script = [NSString stringWithFormat: @"document.body.style.zoom = %1.1f;", scale];
    [self.webView evaluateJavaScript: script
                   completionHandler:nil];
}
- (void) showKeyboard {
    if (![self.view isFirstResponder]) {
        self.view.inputAccessoryView.hidden = false;
        [self.view becomeFirstResponder];
    } else {
        [self.view resignFirstResponder];
    }
    
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *sentData = (NSDictionary*)message.body;
    NSString* action = sentData[@"action"];
    self.selectID = sentData[@"id"];  //Store element ID in web report
    
    
    if ([action isEqual: @"openCameraRoll"]) {
        [self openCameraRoll];

    } else if ([action isEqual:@"enterText"]) {
        NSString* currentText = sentData[@"text"];
        [self.view setText:currentText];
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
    UIImagePickerController *picker = [UIImagePickerController new];
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
    
    [picker dismissViewControllerAnimated:true completion:nil];
    
}

#pragma mark - KeyboardBarDelegate

/*
 * When user taps on button Save, text content in textView will be pass to this delegate function
 * We need to convert to HTML before assign it to report
 */
- (void)onKeyboard:(CustomKeyBoard *)customKeyBoard save:(NSString *)text {
    //I use HTMLConverter from https://github.com/TakahikoKawasaki/nv-ios-html-converter
    NSString* htmlText = [[self.htmlConverter toHTML:text] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    
    NSString* script = [NSString stringWithFormat:@"Vue.set(app, '%@', '%@')", self.selectID , htmlText];
    

    [self.webView evaluateJavaScript:script
                   completionHandler:nil];
}

- (void)onKeyboardClose:(CustomKeyBoard *)customKeyBoard {
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"clearSelectedText('%@')", self.selectID]
                   completionHandler:nil];
    self.selectID = @""; //Clear selectedID after
    
}
@end
