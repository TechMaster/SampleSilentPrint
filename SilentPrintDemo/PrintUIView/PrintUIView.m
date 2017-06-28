//
//  PrintUIView.m
//  SilentPrintDemo
//
//  Created by cuong on 6/23/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "PrintUIView.h"
#import <WebKit/WebKit.h>
#import "SilentPrint.h"

@interface PrintUIView () <SilentPrintDelegate>
@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, weak) SilentPrint* silentPrint;
@end

@implementation PrintUIView
- (void) loadView {
    [super loadView];
    WKWebViewConfiguration *theConfiguration = [WKWebViewConfiguration new];
    
    self.webView = [[WKWebView alloc] initWithFrame: self.view.bounds
                                      configuration: theConfiguration];
    
    [self.view addSubview:self.webView];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Print"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(printView)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL: [[NSURL alloc] initWithString:@"https://github.com/techmaster"]];
    [self.webView loadRequest: request];
    self.silentPrint = [SilentPrint getSingleton];
    self.silentPrint.silentPrintDelegate = self;
}


- (void) printView {
    if (!self.webView.isLoading) {
        //[self.silentPrint printUIView:self.webView jobName:@"Print web" show:false];
        PrintJob* job = [[PrintJob alloc] init:self.webView
                                      withRect:CGRectNull
                                      withView:nil
                                 withBarButton:self.navigationItem.rightBarButtonItem];
        
        [self.silentPrint printAJob: job];
    }
}

#pragma mark - SilentPrintDelegate
-(void)onSilentPrintError: (NSError*) error {
     if (error.code == PRINTER_IS_OFFLINE || error.code == PRINTER_IS_NOT_SELECTED) {
        [self.silentPrint configureSilentPrint: CGRectZero
                                        inView: nil
                           orFromBarButtonitem: self.navigationItem.rightBarButtonItem
                                    completion:^{
                                        [self.silentPrint retryPrint];
                                    }];
    }
}

- (void) onPrintJobCallback:(NSString *)jobName
                  withError:(NSUInteger)errorCode {
    
    
    if (errorCode == PRINT_SUCCESS) {
        
    } else {
     
    }
}


@end
