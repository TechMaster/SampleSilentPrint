//
//  GenerateImagesCollection.m
//  SilentPrintDemo
//
//  Created by cuong on 5/15/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "GenerateImagesCollection.h"
#import <WebKit/WebKit.h>
#import "PDFGenerator.h"
#import "UIImage+Utils.h"
#import "ConstantKeys.h"

@interface GenerateImagesCollection ()
@property (nonatomic, strong) PDFGenerator* generator;
@property (nonatomic, strong) WKWebView* webView;
@property (nonatomic, strong) SilentPrint* silentPrint;
@property (nonatomic, strong) PaperConfig* paperConfig;
@end

@implementation GenerateImagesCollection

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview: self.webView];
    
    
    UIBarButtonItem* generateReport = [[UIBarButtonItem alloc] initWithTitle:@"Report"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(generateReport)];
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItems = @[generateReport];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Print"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(printDocument)];
    
    self.generator = [PDFGenerator new];
    self.silentPrint = [SilentPrint getSingleton];
    self.silentPrint.silentPrintDelegate = self;

    self.paperConfig = [[PaperConfig alloc] initPaperType:PaperTypeLetter
                                              orientation:PaperOrientationPortrait
                                                marginTop:0
                                             marginBottom:0
                                              marginRight:0
                                               marginLeft:0];
}
#pragma mark - Prepare Data
/*
 Calculate max width of image when layout number of images (imagePerPage) in a page that have width (pageWidth)
 */
- (float) imageWidthToScale: (int) imagePerPage
              withPageWidth: (float) pageWidth {
    switch (imagePerPage) {
        case 1:
            return pageWidth;
            break;
        case 2:
            return pageWidth / 1.5;
            break;
        case 3:
            return pageWidth / 2;
        case 4:
            return pageWidth / 2;
        case 5:
            return pageWidth / 2;
        case 6:
            return pageWidth / 2;
            break;
        default:
            return pageWidth / 3;
            break;
    }
}
/*
 Generate JSON array of random photo
 */
- (NSString*) generateSelectedImages: (int) imagesPerPage {
    NSArray* imagesArray = @[
                             @{@"file": @"01.jpg", @"desc": @"Violet flower"},
                             @{@"file": @"02.jpg", @"desc": @"Hong Kong"},
                             @{@"file": @"03.jpg", @"desc": @"Sunshine in mountain"},
                             @{@"file": @"04.jpg", @"desc": @"Falling strawbery"},
                             @{@"file": @"05.jpg", @"desc": @"Pakistan crepe"},
                             @{@"file": @"06.jpg", @"desc": @"Bike chain"},
                             @{@"file": @"07.jpg", @"desc": @"King frog"},
                             @{@"file": @"08.jpg", @"desc": @"Breakfast"},
                             @{@"file": @"09.jpg", @"desc": @"Stone Hedge"},
                             @{@"file": @"10.jpg", @"desc": @"Time for beer"},
                             @{@"file": @"11.jpg", @"desc": @"Light bulb in rain"},
                             @{@"file": @"12.jpg", @"desc": @"Ever green"},
                             @{@"file": @"13.jpg", @"desc": @"Black berry"},
                             @{@"file": @"14.jpg", @"desc": @"Dad and son walking rail way"},
                             @{@"file": @"15.jpg", @"desc": @"Coffee beans"},
                             @{@"file": @"16.jpg", @"desc": @"Cherry Blossom"},
                             @{@"file": @"17.jpg", @"desc": @"Gecko on stone"},
                             @{@"file": @"18.jpg", @"desc": @"Dad car"},
                             @{@"file": @"19.jpg", @"desc": @"Surfing in Danang"},
                             @{@"file": @"20.jpg", @"desc": @"Cookie"},
                             @{@"file": @"21.jpg", @"desc": @"Desert fox"},
                             @{@"file": @"22.jpg", @"desc": @"Dump man"},
                             @{@"file": @"23.jpg", @"desc": @"Green hope"},
                             @{@"file": @"24.jpg", @"desc": @"White lamp"},
                             @{@"file": @"25.jpg", @"desc": @"Morning Farm"},
                             @{@"file": @"26.jpg", @"desc": @"Silent wave"},
                             @{@"file": @"27.jpg", @"desc": @"Light house"},
                             @{@"file": @"28.jpg", @"desc": @"Oceana"},
                             @{@"file": @"29.jpg", @"desc": @"Sky scrapper"},
                             @{@"file": @"30.jpg", @"desc": @"Mang Tay"}
                             ];
    NSUInteger totalImages = imagesArray.count;
    int numberSelectedImages = arc4random() % totalImages;
    
    
    //NSArray* selectedImages = [imagesArray subarrayWithRange:NSMakeRange(0, numberSelectedImages)];
    
    
    //Scale down size of image to reduce file size of PDF
    NSMutableArray * selectedImages = [[NSMutableArray alloc] initWithCapacity:numberSelectedImages];
    
    for (int i = 0; i < numberSelectedImages; i++) {
        NSDictionary* imageItem = imagesArray[i];
        
        NSString* file = [imageItem valueForKey:@"file"];
        
        NSString* inputPath = [[NSBundle mainBundle] pathForResource:[file stringByDeletingPathExtension]
                                                              ofType:[file pathExtension]];
        NSString* outputPath = [UIImage scaleDownImage: inputPath
                                              maxWidth: [self imageWidthToScale:imagesPerPage
                                                                  withPageWidth:800]];
        
        NSDictionary* scaledImageItem = @{@"file": outputPath, @"desc" : [imageItem valueForKey:@"desc"]};
        [selectedImages addObject:scaledImageItem];
        
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:selectedImages
                                                       options:(NSJSONWritingOptions) (NSJSONWritingPrettyPrinted)
                                                         error:&error];
    
    
    if (!jsonData) {
        NSLog(@"Error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

}
- (NSDictionary*) generateData {
    int imagesPerPage = 4;
    NSString* jsonString = [self generateSelectedImages:imagesPerPage];
    
    return @{
             kLogo: @"logo1.png",
             
             kTopDoctorText: @"Cardiovascular Surgery<br>\
             Room 1503, Block C<br>\
             Phone: 0902209011<br>\
             Email: Zhivago@mayo.org",
             
             kDoctorImage: @"doctor1.jpg",
             
             kBottomDoctorText: @"Doctor Ivan Zhivago Baker",
             
             kGreetingText: @"Welcome to Heart Surgery Dept",
             
             
             @"images": jsonString, //selectedImages
             @"imagesPerPage": @(imagesPerPage) //Number of image per page
             };
    
}
- (void) generateReport {
    [self generatePDF:[self generateData]];
}


#pragma mark - Generate PDF
- (void) generatePDF: (NSDictionary*) data {
    [self.generator generateHTML: data
                 withPaperConfig: self.paperConfig
                    fromResource: @"PortraitLetterPhoto"
                          bundle: nil
                      onComplete: ^(NSString *result, NSError *error) {
                          if (error) {
                              NSLog(@"%@", error);
                          } else {
                              NSLog(@"%@", result);
                              NSString *path = [[NSBundle mainBundle] bundlePath];
                              NSURL *baseURL = [NSURL fileURLWithPath:path];
                              [self.webView loadHTMLString:result baseURL: baseURL];
                          }
                      }];
    
}


- (void) printDocument {
    NSString* pdfFile = [NSString stringWithFormat:@"%@tmp.pdf", NSTemporaryDirectory()];
    [self.generator generatePDF: pdfFile
                      ofWebView: self.webView
                withPaperConfig: self.paperConfig
                     onComplete:^(NSString *result, NSError *error) {
                         if (error) {
                             NSLog(@"%@", error);
                         } else {
                             NSLog(@"PDF: %@", result);
                             [self.silentPrint printFile: result
                                                inSilent: false];
                         }
                     }];
}

#pragma mark - SilentPrintDelegate
-(void)onSilentPrintError: (NSError*) error {
    NSLog(@"Error: %@", [error localizedDescription]);
    if (error.code == PRINTER_IS_OFFLINE || error.code == PRINTER_IS_NOT_SELECTED) {
        UIPrinterPickerController *printerPicker = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
        [printerPicker presentAnimated:true completionHandler:^(UIPrinterPickerController * _Nonnull printerPickerController, BOOL userDidSelect, NSError * _Nullable error) {
            if (userDidSelect) {
                self.silentPrint.selectedPrinter = printerPickerController.selectedPrinter;
                [self.silentPrint retryPrint];
            }
        }];
    }
}


@end
