# How to create a nice report using Vue.js

## What make a good report in mobile app?
1. It should not tightly couple with native code
2. It is highly customizable, download the Internet then render in app
3. It can be modified inside or outside app by simple method

## Why I choosed HTML, CSS, Javascript render report in WkWebView?
1. It is easy to code, preview and debug
2. It can be responsive
3. It can interact with user: update text field, select new photo...
4. Developer can 

Look at followings files
![WYSIWYG](WYSIWYGReport.jpg)

## important files

Report view controller must inherit from class WYSIWYG
WYSIWYGReport.h
```objective-c
@interface WYSIWYGReport : UIViewController <UINavigationControllerDelegate, WKScriptMessageHandler, UIImagePickerControllerDelegate, CustomKeyboardDelegate>

@property (nonatomic, readonly) NSString* _Nonnull reportTemplate;
@property (nonatomic, strong) WKWebView* _Nonnull webView;

-(id _Nonnull ) initWithReportTemplate: (NSString*_Nonnull)  report;
-(void) applyJSONDataToReport: (NSString*_Nonnull) json
            completionHandler: (void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;
@end
```


Sample initialization
```objective-c
@implementation PatientReport
- (id) init {
    return [super initWithReportTemplate:@"patient_report"];
}
```

## How to pass data into report
Look at file [ReportDataInOut/ReportDataInOut.m](https://github.com/TechMaster/SampleSilentPrint/blob/master/SilentPrintDemo/ReportDataInOut/ReportDataInOut.m)

method that pass JSON to Vue application
```objective-c
-(void) applyJSONDataToReport: (NSString*) json
            completionHandler: (void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler
{
    [self.webView evaluateJavaScript: [NSString stringWithFormat: @"setData(%@);", json]
                   completionHandler: completionHandler];
}
```

A HTML - Vue.js web report [looks like](https://github.com/TechMaster/SampleSilentPrint/blob/master/SilentPrintDemo/Report/patient_report_inout.html)

it refers to [report_data.js](https://github.com/TechMaster/SampleSilentPrint/blob/master/SilentPrintDemo/Report/report_data.js)
