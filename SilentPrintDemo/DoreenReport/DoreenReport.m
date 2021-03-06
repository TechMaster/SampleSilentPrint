//
//  DoreenReport.m
//  SilentPrintDemo
//
//  Created by cuong on 7/18/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "DoreenReport.h"
#import "PDFGenerator.h"
#import "LENSReportKey.h"
#import "UIImage+Utils.h"
#import "HTMLConverter.h"

@interface DoreenReport ()
@property (nonatomic, strong) PDFGenerator* generator;
@property (nonatomic, strong) SilentPrint* silentPrint;
@property (nonatomic, strong) PaperConfig* paperConfig;
@property (nonatomic, assign) int imagesPerPage;
@property (nonatomic, assign) int numberSelectedImages;
@end

@implementation DoreenReport




- (id) init {
    return [super initWithReportTemplate:@"patient_report_inout"];
}

- (void) viewDidLoad {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Generate PDF"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(applyData)];
    
    self.generator = [PDFGenerator new];
    self.silentPrint = [SilentPrint getSingleton];
    self.silentPrint.silentPrintDelegate = self;
    
    self.paperConfig = [[PaperConfig alloc] initPaperType:PaperTypeLetter
                                              orientation:PaperOrientationPortrait
                                                marginTop:0
                                             marginBottom:0
                                              marginRight:0
                                               marginLeft:0];
    [self.webView removeFromSuperview];   
    self.view.backgroundColor = [UIColor whiteColor];
    self.enableInteraction = FALSE;
}

- (void) savePDF {
    NSString* pdfFile = [NSString stringWithFormat:@"%@tmp.pdf", NSTemporaryDirectory()];
    [self.generator generatePDF: pdfFile
                      ofWebView: self.webView
                withPaperConfig: self.paperConfig
                     onComplete:^(NSString *result, NSError *error) {
                         if (error) {
                             NSLog(@"%@", error);
                         } else {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self informPDFSaveSuccess: pdfFile];
                             });
                         }
                     }];
}



- (void) informPDFSaveSuccess: (NSString*) pdfFile {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Save PDF success"
                                                                   message:[NSString stringWithFormat:@"PDF file is created at %@", pdfFile]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Print PDF" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              PrintJob* job = [[PrintJob alloc] init:pdfFile
                                                                                            withShow:TRUE];
                                                              [self.silentPrint printAJob:job];
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - SilentPrintDelegate
-(void)onSilentPrintError: (NSError*) error {
    if (error.code == PRINTER_IS_OFFLINE || error.code == PRINTER_IS_NOT_SELECTED) {
        [self.silentPrint configureSilentPrint:CGRectZero
                                        inView:nil
                           orFromBarButtonitem: self.navigationItem.rightBarButtonItem
                                    completion:^{
                               [self.silentPrint retryPrint];
                           }];
    }
}

-(void)onPrintJobCallback: (NSString*) jobName
                withError: (NSUInteger) errorCode {
    
}
#pragma mark - Prepare Data
/*
 * Apply data as JSON string to Vue report
 */
-(void) applyData {

    self.imagesPerPage = 4;
    NSDictionary* paramCollection = [self generateParamCollection];
    NSArray* selectedImages = [self generateSelectedImages];
    [self generatePDFReport:paramCollection
                otherParams:selectedImages];
    
    
}
/*
 * I rearrange logic to meet Doreen requirement
 */
- (void)generatePDFReport: (NSDictionary *)paramCollection
              otherParams: (NSArray *)selectedImages {
    
    NSMutableDictionary* data = [[NSMutableDictionary alloc] initWithDictionary:paramCollection];
    [data setObject:selectedImages
             forKey:@"selectedImages"];
    
    [data setObject:@(self.imagesPerPage)
             forKey:@"imagesPerPage"];
    
    
    NSString* jsonString = [HTMLConverter convertObjectToJSON:data];
    
    //Apply data to Vue report
    [self applyJSONDataToReport:jsonString
              completionHandler:^(id _Nullable xyz, NSError * _Nullable error) {
                  //then layoutPhoto in report
                  [self.webView evaluateJavaScript:@"layoutPhotoVue();"
                                 completionHandler:^(id obj, NSError * error) {
                                     //then save to PDF
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self savePDF];
                                     });
                                     
                                 }];
              }];

}


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
- (NSArray*) generateSelectedImages {
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
    _numberSelectedImages = arc4random() % totalImages;
    
    if (_numberSelectedImages < _imagesPerPage) {
        _imagesPerPage = _numberSelectedImages;
    }
    
    NSLog(@"Selected Images: %d - Image Per Page: %d", _numberSelectedImages, _imagesPerPage);
    
    //Must call this method to delete old generated resized image from previous run
    [UIImage initTempResizedImageFolder];
    
    //Scale down size of image to reduce file size of PDF
    NSMutableArray * selectedImages = [[NSMutableArray alloc] initWithCapacity: _numberSelectedImages];
    
    for (int i = 0; i < _numberSelectedImages; i++) {
        NSDictionary* imageItem = imagesArray[i];
        
        NSString* file = [imageItem valueForKey:@"file"];
        
        NSString* inputPath = [[NSBundle mainBundle] pathForResource:[file stringByDeletingPathExtension]
                                                              ofType:[file pathExtension]];
        NSString* outputPath = [UIImage scaleDownImage: inputPath
                                              maxWidth: [self imageWidthToScale:_imagesPerPage
                                                                  withPageWidth:800]];
        
        NSDictionary* scaledImageItem = @{@"file": outputPath, @"desc" : [imageItem valueForKey:@"desc"]};
        [selectedImages addObject:scaledImageItem];
        
    }
    
    return selectedImages;
    
}
- (NSDictionary*) generateParamCollection {
    return @{
             @"PatientReport": @"1", //If this key has non-empty string, then 1st page Patient Report will be shown
             
             //1st page: Patient Report
             @"reportLogo": @"logo1.png",
             
             @"topDoctorText": @"Cardiovascular Surgery<br>\
                 Room 1503, Block C<br>\
                 Phone: 0902209011<br>\
                 Email: Zhivago@mayo.org",
             
             @"topDoctorImage": @"doctor1.jpg",
             
             @"bottomDoctorText": @"Doctor Ivan Zhivago Baker",
             
             @"greetingText": @"<p align=\"right\"><font face=\"Smith&NephewLF\"  style=\"font-size:32px; color:rgb(255,115,0); \">Welcome to Heart Surgery Dept</font></p>",
             
             @"surgeryInfoText": @"<p align=\"left\"><font face=\"Smith&NephewLF\"  style=\"font-size:17px; color:rgb(255,115,0); \">Endoscopic surgery is a method of operating on internal body structures, such as knee joints or reproductive organs, by passing an instrument called an endoscope through a body opening or tiny incision.</font></p>",
             
             @"bottomText1": @"Washed the incision. Change to bandage every 2 days",
             @"bottomText2": @"Patient is in good condition. He needs to take rest for 2 week",
             
             @"bottomImageHeader1": @"Helena Jokovic",
             @"bottomImageHeader2": @"Van Basten",
             
             @"bottomImage1": @"doctor2.jpg",
             @"bottomImage2": @"doctor3.jpg",
             
             @"bottomImageCaption1": @"Surgery assistant",
             
             @"bottomImageCaption2": @"Rehabilitation nurse",
             
             //2nd page------------
             @"reportLine1": @"Doctor: Wantanabe",
             @"reportLine2": @"Mayo Clinic - Cardio Surgery",
             @"reportLine3": @"Zhivago@gmail.com",
             
             @"reportLine4": @"Patient: John Silver Bank",
             @"reportLine5": @"MRN: 212-485",
             @"reportLine6": @"Surgery date 2017-06-10",
             
             
             @"doctorInfoLogo" : @"logo1.png",
             
             //data for selected images in consequence page
             //@"selectedImages": selectedImages, //selectedImages
             @"imagesPerPage": @(_imagesPerPage), //Number of image per page
             
             };
    
}


@end

