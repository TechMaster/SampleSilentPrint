//
//  PDFGenerator.m
//  RebuildLib
//
//  Created by Tuuu on 11/3/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

#import "PDFGeneratorFile.h"
#import "NSString+PageNumber.h"
#import <GRMustache/GRMustache.h>
#import "ConstantKeys.h"
#import "PDFPageRender.h"

@interface PDFGeneratorFile () <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, copy) void (^onCompleteBlock)(NSError *error);
@property (nonatomic, strong) WKWebView *previewPDF;
@property (nonatomic, strong) UIView *subview;
@property (nonatomic, assign) NSString *output;
@property (nonatomic) CGSize paperSize;
@property (nonatomic, assign) BOOL singleDigital;
@end

@implementation PDFGeneratorFile
- (instancetype)initWith:(NSString *)output
{
    self.output = output;
    self.paperSize = kPaperSizeLetter;
    return self;
}
-(void)configToGeneratePDF:(NSDictionary *)config;
{
    //get size each paper
    self.paperSize = [config[KPaperSize] CGSizeValue];
    //get numberingFormatSingleDigit
    self.singleDigital = [config[kNumberingFormatSingleDigit] boolValue];
}

/*
 * Generate HTML document using GRMustacheTemplate libary
 */
-(void)generatePDFWith:(NSDictionary *)components //data
            collection:(NSDictionary *)params //configuration parameters
                images:(NSArray *)selectedImages
               subView:(UIView *)subview
            OnComplete: (void (^)(NSError *error))onCompleteBlock
{
    self.onCompleteBlock = onCompleteBlock;
    self.subview = subview;
    self.paperSize = [params[KPaperSize] CGSizeValue];
    self.singleDigital = [params[kNumberingFormatSingleDigit] boolValue];
    NSError *error = nil;
    
    //Load mustache template Document
    GRMustacheTemplate *template = [GRMustacheTemplate templateFromResource:@"Document" bundle:[NSBundle bundleForClass: [PDFGeneratorFile class]] error:&error];
    
    //Call error handling
    if (error)
    {
        [self.delegate showError:[error description]];
        return;
    }
    
    //Configure number of image per page
    NSNumber *getKnumberImagesPerPage = params[kNumberImagesPerPage];
    int numberOfImagesPerPage = [getKnumberImagesPerPage intValue];
    
    //save collectionView to variable components before render data to HTML because special characters will be replace, don't show correctly HTML tags with attributes.
    NSDictionary *subComponents = components;
    Filter *filterData = [Filter new];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:[filterData convertArraySelectedImagesToDictionary:selectedImages]];
    data[kPageOrientation] = params[kPageOrientation];
    data[kImageWidth] = [NSString stringWithFormat:@"%f", kPaperSizeA4.width/numberOfImagesPerPage];
    data[kImageHeight] = [NSString stringWithFormat:@"%f", kPaperSizeA4.height/numberOfImagesPerPage];
    [data addEntriesFromDictionary:[filterData replaceValuesToKeys:components]];
    
    NSString *rendering = [template renderObject:data error:nil];
    
    
    //restore correctly format
    rendering = [filterData addRawValuesToHTML:subComponents htmlString:rendering];

    self.previewPDF = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.previewPDF.navigationDelegate = self;
    self.previewPDF.scrollView.contentSize = CGSizeMake(self.paperSize.width, self.paperSize.height);
    [self.previewPDF loadHTMLString:rendering baseURL:[[NSBundle bundleForClass: [PDFGeneratorFile class]] bundleURL]];
}
-(void)generatePDFWithAView:(UIView *)aView
{
    UIView *currentView = [self addPageNumbersForImages:aView];
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, currentView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [currentView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:self.output atomically:YES];
}
-(void)generatePDFWithAWebView:(WKWebView *)aWebView
{
    if (aWebView.isLoading)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        PDFPageRender *render = [[PDFPageRender alloc] init];
        [render addPrintFormatter:aWebView.viewPrintFormatter startingAtPageAtIndex:0];
        
        render.singleDigit = self.singleDigital;
        //increase these values according to your requirement
        CGRect printableRect = CGRectMake(0,
                                          Top_Padding,
                                          kPaperSizeLetter.width,
                                          kPaperSizeLetter.height - Top_Padding * 2);
        CGRect paperRect = CGRectMake(0, 0, kPaperSizeLetter.width, kPaperSizeLetter.height);
        [render setValue:[NSValue valueWithCGRect:paperRect] forKey:@"paperRect"];
        [render setValue:[NSValue valueWithCGRect:printableRect] forKey:@"printableRect"];
        render.footerText = @"";
        NSData *pdfData = [render printToPDF:self.subview];
        if (pdfData) {
            [pdfData writeToFile:self.output atomically: YES];
        }
        else
        {
            NSLog(@"PDF couldnot be created");
        }
    });
    
}
-(void)generatePDFWith:(WKWebView *)aWebView
              andAView:(UIView *)aView
{
    self.subview = aView;
    [self generatePDFWithAWebView:aWebView];
}
- (UIView *)addPageNumbersForImages:(UIView *)pdfView{
    UIView *subPDFView = pdfView;
    float labelWidth = 120, labelHeight = 21;
    float originX = (self.paperSize.width - labelWidth) / 2;
    float originY = self.paperSize.height - (labelHeight + 15);
    
    int totalPage = subPDFView.bounds.size.height / self.paperSize.height;
    UIFont *font = [UIFont systemFontOfSize:12];
    
    for (int i = 0; i < totalPage; i ++) {
        UILabel *pageNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
        int pageNumber = i + 1;
        pageNumLabel.text = [NSString numberOfPageWithFormat:pageNumber
                                                 totalNumber:totalPage
                                             isSingleDigital:self.singleDigital];
        pageNumLabel.font = font;
        [subPDFView addSubview:pageNumLabel];
        originY += self.paperSize.height;
    }
    return subPDFView;
}

- (BOOL) mergePDFFiles:(NSArray *)sourcePaths outPath:(NSString *)outPath{
    
    CFURLRef pdfURLOutput = (__bridge CFURLRef)[NSURL fileURLWithPath:outPath];
    NSInteger numberOfPages = 0;
    
    // Create the output context
    CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
    
    for (NSString *source in sourcePaths) {
        const UInt8 *pFilepath = (const UInt8 *)[source UTF8String];
        CFURLRef pdfURL = CFURLCreateFromFileSystemRepresentation(NULL, pFilepath, [source length], NO);
        
        //file ref
        CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL(pdfURL);
        numberOfPages = CGPDFDocumentGetNumberOfPages(pdfRef);
        
        // Loop variables
        CGPDFPageRef page;
        CGRect mediaBox;
        
        // Read the first PDF and generate the output pages
        // NSLog(@"GENERATING PAGES FROM PDF 1 (%@)...%ld", source, (long)numberOfPages);
        for (int i=1; i<=numberOfPages; i++) {
            page = CGPDFDocumentGetPage(pdfRef, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
        
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        
        CGPDFDocumentRelease(pdfRef);
        CFRelease(pdfURL);
    }
    CGPDFContextClose(writeContext);
    CGContextRelease(writeContext);
    
    if ([[NSFileManager defaultManager] isReadableFileAtPath:outPath]) {
        return true;
    } else {
        return false;
    }
}


//wkwebview delegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.onCompleteBlock(nil);
    [self generatePDFWithAWebView:webView];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    self.onCompleteBlock(error);
}



@end
