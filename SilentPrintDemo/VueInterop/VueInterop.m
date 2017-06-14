//
//  VueInterop.m
//  SilentPrintDemo
//
//  Created by cuong on 6/4/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "VueInterop.h"
#import "UIImage+Utils.h"

@interface VueInterop ()
@property(nonatomic, strong) NSString* selectID;
@end

@implementation VueInterop

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"letter_portrait_vue"
                                                     ofType:@"html"];
    
    NSString* htmlString = [NSString stringWithContentsOfFile: path
                                                     encoding: NSUTF8StringEncoding
                                                        error: nil];
    
    WKWebViewConfiguration *theConfiguration = [WKWebViewConfiguration new];
    
    [theConfiguration.userContentController addScriptMessageHandler:self
                                                               name:@"interOp"];
    
    self.webView = [[WebViewTextInput alloc] initWithFrame:self.view.frame
                                      configuration:theConfiguration];
   
    
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
    [self.view addSubview:self.webView];
}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"w = %f, h = %f", size.width, size.height);
    self.webView.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *sentData = (NSDictionary*)message.body;
    if ([sentData[@"action"]  isEqual: @"openCameraRoll"]) {
        NSLog(@"%@", sentData[@"id"]);
        self.selectID = sentData[@"id"];
        [self openCameraRoll];

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
@end
