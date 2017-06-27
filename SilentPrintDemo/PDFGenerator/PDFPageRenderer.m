//
//  PDFPageRenderer.m
//  SilentPrintDemo
//
//  Created by cuong on 5/12/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "PDFPageRenderer.h"
//#import <WebKit/WebKit.h>

@implementation PDFPageRenderer
- (NSData*) printToPDF
{
    NSMutableData *pdfData = [NSMutableData data];
    NSLog(@"x = %f, y = %f, w = %f, h =%f", self.paperRect.origin.x, self.paperRect.origin.y, self.paperRect.size.width, self.paperRect.size.height);
    
    UIGraphicsBeginPDFContextToData( pdfData, self.paperRect, nil );
    [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];
    CGRect bounds = UIGraphicsGetPDFContextBounds();
    
    /*NSLog(@"x = %f, y = %f, w = %f, h =%f", bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);*/
    for ( int i = 0 ; i < self.numberOfPages ; i++ )
    {
        UIGraphicsBeginPDFPage();
        [self drawPageAtIndex: i inRect: bounds];
    }
    UIGraphicsEndPDFContext();
    return pdfData;
}
@end
