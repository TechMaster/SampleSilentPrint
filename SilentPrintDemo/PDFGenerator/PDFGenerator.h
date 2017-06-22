//
//  PDFGenerator.h
//  SilentPrintDemo
//
//  Created by cuong on 5/11/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "PaperConfig.h"

#define WKWEBVIEW_IS_LOADING            100
#define WKWEBVIEW_RENDER_NO_PDF_DATA    150

typedef void (^onGenerateComplete)(NSString* _Nullable result, NSError*  _Nullable error);

@interface PDFGenerator : NSObject

-(void)generatePDF: (NSString* _Nonnull) fileOutput
         ofWebView: (WKWebView* _Nonnull) webView
   withPaperConfig: (PaperConfig* _Nonnull) paperConfig
        onComplete: (onGenerateComplete _Nonnull) complete;


@end


