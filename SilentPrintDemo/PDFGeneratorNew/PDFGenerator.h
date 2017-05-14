//
//  PDFGenerator.h
//  SilentPrintDemo
//
//  Created by cuong on 5/11/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <GRMustache/GRMustache.h>
#import "PaperConfig.h"

#define WKWEBVIEW_IS_LOADING            100
#define WKWEBVIEW_RENDER_NO_PDF_DATA    150

typedef void (^onGenerateComplete)(NSString* _Nullable result, NSError*  _Nullable error);

@interface PDFGenerator : NSObject

-(void) generateHTML: (NSDictionary* _Nonnull) data
       usingTemplate: (NSString* _Nonnull) template
          onComplete: (onGenerateComplete _Nonnull ) complete;

-(void) generateHTML: (NSDictionary*_Nonnull) data
     withPaperConfig: (PaperConfig* _Nullable) paperConfig
        fromResource: (NSString*_Nonnull) name
              bundle: (NSBundle *_Nullable) bundle
          onComplete: (onGenerateComplete _Nonnull) complete;

-(void)generatePDF: (NSString* _Nonnull) fileOutput
         ofWebView: (WKWebView* _Nonnull) webView
   withPaperConfig: (PaperConfig* _Nullable) paperConfig
        onComplete: (onGenerateComplete _Nonnull) complete;
@end


