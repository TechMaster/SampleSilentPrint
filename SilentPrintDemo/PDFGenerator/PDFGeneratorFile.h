//
//  PDFGenerator.h
//  RebuildLib
//
//  Created by Tuuu on 11/3/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//


#import <WebKit/WebKit.h>
@protocol PDFGeneratorFileDelegate
-(void)showError:(NSString *)error;
@end


@interface PDFGeneratorFile : NSObject
@property(nonatomic, assign) id <PDFGeneratorFileDelegate> delegate;
- (instancetype)initWith:(NSString *)output;
-(void)configToGeneratePDF:(NSDictionary *)config;
-(void)generatePDFWith:(NSDictionary *)components
             collection:(NSDictionary *)params
                 images:(NSArray *)selectedImages
                subView:(UIView *)subview
             OnComplete: (void (^)(NSError *error))onCompleteBlock;

-(void)generatePDFWithAWebView:(WKWebView *)aWebView;
-(void)generatePDFWithAView:(UIView *)aView;
-(void)generatePDFWith:(WKWebView *)aWebView andAView:(UIView *)aView;
@end
