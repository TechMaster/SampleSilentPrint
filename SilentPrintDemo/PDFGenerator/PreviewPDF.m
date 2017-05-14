//
//  PreviewPDF.m
//  SlientPrint
//
//  Created by Tuuu on 10/26/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

#import "PreviewPDF.h"
#import <WebKit/WebKit.h>
#import <GRMustache/GRMustache.h>
#import "ConstantKeys.h"

@interface PreviewPDF () <WKUIDelegate, WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *previewPDF;

@end

@implementation PreviewPDF

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)previewPDFReport:(NSDictionary *)components
             andSubView:(UIView *)subView
{
    NSError *error = nil;
    GRMustacheTemplate *template = [GRMustacheTemplate templateFromResource:@"Document" bundle:[NSBundle bundleForClass: [PreviewPDF class]] error:&error];
    if (error != nil)
    {
        [self.delegate showError:[error description]];
        return;
    }
    
    
    //save collectionView to variable components before render data to HTML because special characters will be replace so don't show correctly tags with attributes.
    NSDictionary *subComponents = components;
    NSMutableDictionary *data = [NSMutableDictionary new];
    Filter *filterData = [[Filter alloc] init];
    [data addEntriesFromDictionary:[filterData replaceValuesToKeys:components]];
    
    NSString *rendering = [template renderObject:data error:nil];
    //restore correctly format
    rendering = [filterData addRawValuesToHTML:subComponents htmlString:rendering];
    
    CGRect rectPreview = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.previewPDF = [[WKWebView alloc] initWithFrame:rectPreview];
    [self.previewPDF loadHTMLString:rendering baseURL:[[NSBundle bundleForClass: [PreviewPDF class]] bundleURL]];
    self.previewPDF.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    subView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width - 2*Left_Padding - self.leftViewWidth, subView.frame.size.height);
    self.previewPDF.scrollView.contentInset = UIEdgeInsetsMake(self.previewPDF.scrollView.contentInset.top, 0, self.previewPDF.scrollView.contentInset.bottom + subView.frame.size.height, 0);
    [self.previewPDF.scrollView addSubview:subView];
    [self.view addSubview:self.previewPDF];
    
}


@end


