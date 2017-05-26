# How use PDF Generation library

PDF Generator library depends on two Apple Libraries and one 3rd party library
1. ImageIO: scale image resolution. It performs better than UIKit
2. WebKit: display web page
3. [Mustache](https://github.com/groue/GRMustache): template library. Use CocoaPod to install

**Source codes of PDF Generator**
- PaperConfig.h 
- PaperConfig.m   //configure page size, orientation, margin
- PDFGenerator.h
- PDFGenerator.m    //Convert data + mustache --> HTML
- PDFPageRenderer.h
- PDFPageRenderer.m //Format to render PDF
- UIImage+Utils.h
- UIImage+Utils.m //resize image
- LENSReportKey.h //define place holder fields in report

**Mustache, JavaScript, CSS files to generate Letter size, portrait report for LENS project**
jquery-3.2.1.slim.min.js
LetterPortrait.css
LetterPortrait.js
PortraitLetterPhoto.mustache

We can add more reports as we wish. This PDF Generator is totally decoupled from main application.

**Key functions in PDF Generator**
```objective-c
-(void) generateHTML: (NSDictionary* _Nonnull) data
       usingTemplate: (NSString* _Nonnull) template
          onComplete: (onGenerateComplete _Nonnull ) complete;

-(void) generateHTML: (NSDictionary*_Nonnull) data
     withPaperConfig: (PaperConfig* _Nonnull) paperConfig
        fromResource: (NSString*_Nonnull) name
              bundle: (NSBundle *_Nullable) bundle
          onComplete: (onGenerateComplete _Nonnull) complete;

-(void)generatePDF: (NSString* _Nonnull) fileOutput
         ofWebView: (WKWebView* _Nonnull) webView
   withPaperConfig: (PaperConfig* _Nonnull) paperConfig
        onComplete: (onGenerateComplete _Nonnull) complete;
```

In LENS project, use this function to generate HTML report
```objective-c
-(void) generateHTML: (NSDictionary*_Nonnull) data
     withPaperConfig: (PaperConfig* _Nonnull) paperConfig
        fromResource: (NSString*_Nonnull) name
              bundle: (NSBundle *_Nullable) bundle
          onComplete: (onGenerateComplete _Nonnull) complete;
```

Parameters explanation:
- data: NSDictionary object to pass data (key - value) to render
- paperConfig: to configure paper size of web page as well as PDF rendered from web page. Currently AirPrint only supports Letter size paper. LENS report is Letter sized, portrait paper.
- fromResource: name of template Mustache file, just file name without extension
- bundle: default nil
- onComplete: provide callback function when rendering HTML string is completed

```objective-c
    [self.generator generateHTML: data
                 withPaperConfig: self.paperConfig
                    fromResource: @"PortraitLetterPhoto"
                          bundle: nil
                      onComplete: ^(NSString *result, NSError *error) {
                          if (error) {
                              NSLog(@"%@", error);
                          } else {
                              NSString *path = [[NSBundle mainBundle] bundlePath];
                              NSURL *baseURL = [NSURL fileURLWithPath:path];
                              [self.webView loadHTMLString:result baseURL: baseURL];
                          }
                      }];
```


In callback function, onComplete: we load HTML string into WKWebView
```objective-c
NSString *path = [[NSBundle mainBundle] bundlePath];
NSURL *baseURL = [NSURL fileURLWithPath:path];
[self.webView loadHTMLString:result baseURL: baseURL];
```

then print to PDF
```
NSString* pdfFile = [NSString stringWithFormat:@"%@tmp.pdf", NSTemporaryDirectory()];
[self.generator generatePDF: pdfFile
                  ofWebView: self.webView
            withPaperConfig: self.paperConfig
                 onComplete:^(NSString *result, NSError *error) {
                    if (error) {
                         NSLog(@"%@", error);
                    } else {
                        [self.silentPrint printFile: result
                                           inSilent: false];
                    }
             }];
```

If PDF file is generated successfully, in callback function ```onComplete:^(NSString *result, NSError *error)```, we use SilentPrint to print PDF
