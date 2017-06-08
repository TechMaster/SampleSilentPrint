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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"basic"
                                                     ofType:@"html"];
    
    NSString* htmlString = [NSString stringWithContentsOfFile: path
                                                     encoding: NSUTF8StringEncoding
                                                        error: nil];
    
    WKWebViewConfiguration *theConfiguration = [WKWebViewConfiguration new];
    
    [theConfiguration.userContentController addScriptMessageHandler:self
                                                               name:@"interOp"];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame
                                      configuration:theConfiguration];
   
    
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
    [self.view addSubview:self.webView];
}


- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *sentData = (NSDictionary*)message.body;
    if ([sentData[@"action"]  isEqual: @"openCameraRoll"]) {
        NSLog(@"%@", sentData[@"photoid"]);
        self.selectID = sentData[@"photoid"];
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
