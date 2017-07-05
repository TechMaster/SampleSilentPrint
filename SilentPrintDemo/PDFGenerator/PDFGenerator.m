//
//  PDFGenerator.m
//  SilentPrintDemo
//
//  Created by cuong on 5/11/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "PDFGenerator.h"
#import "PDFPageRenderer.h"

@class PaperConfig;

@implementation PDFGenerator


/*
 Add printing paper configuration to data
 */
-(NSDictionary*) appendPaperConfigToData: (NSDictionary*) data
                         withPaperConfig: (PaperConfig* _Nonnull) paperConfig
{
    
    NSMutableDictionary* appendedData = [[NSMutableDictionary alloc] initWithDictionary:data];
    [appendedData setValue: paperConfig.paperOrientation == PaperOrientationPortrait ? @"portrait" : @"landscape"
                    forKey: @"PaperOrientation"];
    
    [appendedData setValue: paperConfig.paperType == PaperTypeLetter ? @"Letter" : @"A4"
                    forKey: @"PaperType"];
    
    [appendedData setValue: @(paperConfig.marginTop)
                    forKey: @"MarginTop"];
    
    [appendedData setValue: @(paperConfig.marginBottom)
                    forKey: @"MarginBottom"];
    
    
    [appendedData setValue: @(paperConfig.marginLeft)
                    forKey: @"MarginLeft"];
    
    [appendedData setValue: @(paperConfig.marginRight)
                    forKey: @"MarginRight"];
    
    return (NSDictionary*) appendedData;
    
}



-(NSError*)raiseError: (NSInteger) errorCode {
    
    NSString* message = nil;
    switch (errorCode) {
        case WKWEBVIEW_IS_LOADING:
            message = @"WKWebView is loading, cannot generate PDF";
            break;
        case WKWEBVIEW_RENDER_NO_PDF_DATA:
            message = @"WKWebView does not render PDF data";
            break;
        default:
            message = @"Unknown error";
            break;
    }
    
    return [NSError errorWithDomain: @"PDF Generator"
                               code: errorCode
                           userInfo: @{NSLocalizedDescriptionKey: message}
            ];
}
-(CGSize) getPaperSize: (PaperType) paperType {
    switch (paperType) {
        case PaperTypeA4:
            return CGSizeMake(595.2, 841.8);
        case PaperTypeLetter:
            return CGSizeMake(612, 792);
        default:
            return CGSizeMake(612, 792);
    }
}
/**
 http://stackoverflow.com/questions/15813005/creating-pdf-file-from-uiwebview
 */
-(void)generatePDF: (NSString*) fileOutput
         ofWebView: (WKWebView*) webView
   withPaperConfig: (PaperConfig*) paperConfig
        onComplete: (onGenerateComplete) complete;
{
    if (webView.isLoading) {
        complete(NULL, [self raiseError:WKWEBVIEW_IS_LOADING]);
    }
    
    
    PDFPageRenderer* pdfRenderer = [PDFPageRenderer new];
    [pdfRenderer addPrintFormatter:webView.viewPrintFormatter
             startingAtPageAtIndex:0];
    
    
    
    CGSize paperSize = [self getPaperSize:paperConfig.paperType];
    
    CGRect paperRect = CGRectMake(0, 0, paperSize.width, paperSize.height);
    
    //CGRect printableRect = paperRect;
    CGRect printableRect = CGRectMake(paperConfig.marginLeft,
                                      paperConfig.marginTop,
                                      paperRect.size.width - paperConfig.marginLeft - paperConfig.marginRight,
                                      paperRect.size.height - paperConfig.marginTop - paperConfig.marginBottom);
    
    [pdfRenderer setValue:[NSValue valueWithCGRect:paperRect]
                   forKey:@"paperRect"];
    
    [pdfRenderer setValue:[NSValue valueWithCGRect:printableRect]
                   forKey:@"printableRect"];
    
    NSData *pdfData = [pdfRenderer printToPDF];
    
    if (pdfData) {
        [pdfData writeToFile: fileOutput
                  atomically: YES];
        complete(fileOutput, NULL);
    } else {
        complete(NULL, [self raiseError:WKWEBVIEW_RENDER_NO_PDF_DATA]);
    }
}
@end
