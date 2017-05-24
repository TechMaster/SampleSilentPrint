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



-(void) generateHTML: (NSDictionary*) data usingTemplate: (NSString*) template onComplete:  (onGenerateComplete) complete{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error = nil;
        NSString* resultHTML = [GRMustacheTemplate renderObject:data fromString:template error: &error];
        
        if (error) {
            complete(NULL, error);
        } else {
            complete(resultHTML, NULL);
        }
    });
}
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

-(void) generateHTML: (NSDictionary*) data
     withPaperConfig: (PaperConfig*) paperConfig
        fromResource: (NSString*) name
              bundle: (NSBundle *) bundle
          onComplete: (onGenerateComplete) complete{
    
    NSDictionary* appendedData = [self appendPaperConfigToData:data
                                               withPaperConfig:paperConfig];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error = nil;
        NSString* resultHTML = [GRMustacheTemplate renderObject: appendedData
                                                   fromResource: (NSString *) name
                                                         bundle: (NSBundle *) bundle
                                                          error: &error];
        
        if (error) {
            complete(NULL, error);
        } else {
            complete(resultHTML, NULL);
        }
    });
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
    
    CGRect printableRect = paperRect;
    
    //NSLog(@"x = %f, y = %f, w = %f, h =%f", paperRect.origin.x, paperRect.origin.y, paperRect.size.width, paperRect.size.height);
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
