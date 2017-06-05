//
//  VueInterop.m
//  SilentPrintDemo
//
//  Created by cuong on 6/4/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "VueInterop.h"

@interface VueInterop ()

@end

@implementation VueInterop

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index"
                                                     ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    WKWebViewConfiguration *theConfiguration = [WKWebViewConfiguration new];
    
    [theConfiguration.userContentController addScriptMessageHandler:self
                                                               name:@"interOp"];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame
                                      configuration:theConfiguration];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}


- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *sentData = (NSDictionary*)message.body;
    long aCount = [sentData[@"count"] integerValue];
    aCount++;
    
    
    /*[self.webView evaluateJavaScript:[NSString stringWithFormat:@"storeAndShow(%ld)", aCount]
                   completionHandler:nil];*/
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"count": @555, @"data": @"World is wild and fun", @"gender": @true}
                                                       options:(NSJSONWritingOptions) (NSJSONWritingPrettyPrinted)
                                                         error:&error];
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
   
    NSLog(@"%@", jsonString);
    
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"receiveJSON(%@)", jsonString]
                   completionHandler:nil];
}

@end
