//
//  PDFPageRender.h
//  RebuildLib
//
//  Created by Tuuu on 11/3/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

#import "PDFPageRender.h"
#import "NSString+PageNumber.h"
@implementation PDFPageRender
{
    long totalPages;
}
@synthesize headerText=_headerText;
@synthesize footerText=_footerText;


- (void)setHeaderText:(NSString *)newString {
    
    if (_headerText != newString) {
   
        _headerText = [newString copy];
        
        if (_headerText) {
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:HEADER_FONT_SIZE];
            
            CGSize size = [_headerText sizeWithAttributes:@{NSFontAttributeName: font}];
            self.headerHeight = size.height + HEADER_TOP_PADDING + HEADER_BOTTOM_PADDING;
        }
    }
}

- (void)setFooterText:(NSString *)newString {
    
    if (_footerText != newString) {

        _footerText = [newString copy];
        
        if (_footerText) {
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:FOOTER_FONT_SIZE];
            CGSize size = [_footerText sizeWithAttributes:@{NSFontAttributeName: font}];
            self.footerHeight = size.height + FOOTER_TOP_PADDING + FOOTER_BOTTOM_PADDING;
        }
    }
}


#pragma mark === UIPrintPageRendered Methods ===

- (void)drawHeaderForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)headerRect {
    
    if (self.headerText) {
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:HEADER_FONT_SIZE];
        CGSize size = [self.headerText sizeWithAttributes:@{NSFontAttributeName: font}];
        
        // Center Text
        CGFloat drawX = CGRectGetMaxX(headerRect)/2 - size.width/2;
        CGFloat drawY = CGRectGetMaxY(headerRect) - size.height - HEADER_BOTTOM_PADDING;
        CGPoint drawPoint = CGPointMake(drawX, drawY);
        [self.headerText drawAtPoint:drawPoint withAttributes:@{NSFontAttributeName : font}];

    }
}

- (void)drawFooterForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)footerRect {
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:FOOTER_FONT_SIZE];
    
    NSString *pageNumber = [NSString numberOfPageWithFormat:(int)pageIndex + 1
                                                totalNumber:(int)totalPages
                                            isSingleDigital:self.singleDigit];
    CGSize size = [pageNumber sizeWithAttributes:@{NSFontAttributeName: font}];
    CGFloat drawX = CGRectGetMaxX(footerRect)/2 - size.width/2;
    CGFloat drawY = CGRectGetMaxY(footerRect) - size.height - Bottom_Padding;
    CGPoint drawPoint = CGPointMake(drawX, drawY);
    [pageNumber drawAtPoint:drawPoint withAttributes:@{NSFontAttributeName : font}];
}
-(NSData*)printToPDF:(UIView*)aView
{
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData( pdfData, self.paperRect, nil );
    
    [self prepareForDrawingPages: NSMakeRange(0, self.numberOfPages)];
    
    CGRect bounds = UIGraphicsGetPDFContextBounds();
    [self calculateTotalPages:aView andBounds:bounds];
    [self renderPDFFile:aView bounds:bounds];
    return pdfData;
}
-(NSMutableData *)createPDFDatafromUIView:(UIView*)aView
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    // Points the pdf converter to the mutable data object and to the UIView to be converted

    
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    
    for(UIView *view in [aView subviews])
    {
            UIGraphicsBeginPDFPage();
            CGContextRef pdfContext = UIGraphicsGetCurrentContext();
            
            // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
            [view.layer renderInContext:pdfContext];

    }
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    return pdfData;
}

-(void)renderPDFFile:(UIView *)aView bounds:(CGRect)bounds
{
    int currentIndex = 0;
    for (; currentIndex < self.numberOfPages ; currentIndex++ )
    {
        UIGraphicsBeginPDFPage();
        [self drawPageAtIndex:currentIndex inRect:bounds];
    }
    
    if (aView != nil)
    {
//        aView.bounds = CGRectMake(Left_Padding, Top_Padding, bounds.size.width - Left_Padding*2, bounds.size.height - Top_Padding*2);
        for (CGFloat pageOriginY = 0; currentIndex < totalPages; currentIndex++, pageOriginY += bounds.size.height) {
            UIGraphicsBeginPDFPage();
            [self drawPageAtIndex:currentIndex inRect:bounds];
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, - pageOriginY);
            [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
            
        }
    }
    UIGraphicsEndPDFContext();
}
-(void)calculateTotalPages:(UIView *)aView andBounds:(CGRect)bounds
{
    CGSize fittedSize = ((UIScrollView *)aView).contentSize;
    if (aView != nil)
    {
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            float page = fittedSize.height/bounds.size.height;
            totalPages = self.numberOfPages + ceil(page);
        }
        else
        {
            totalPages = self.numberOfPages + 1;
        }
        
    }
    else
    {
        totalPages = self.numberOfPages;
    }
}
@end
