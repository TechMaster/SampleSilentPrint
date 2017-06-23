//
//  VueInterop.h
//  SilentPrintDemo
//
//  Created by cuong on 6/4/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "CustomKeyBoard.h"

@interface WYSIWYGReport : UIViewController <UINavigationControllerDelegate, WKScriptMessageHandler, UIImagePickerControllerDelegate, CustomKeyboardDelegate>



@property (nonatomic, readonly) NSString* reportTemplate;
@property (nonatomic, strong) WKWebView* webView;

-(id) initWithReportTemplate: (NSString*)  report;
-(void) applyJSONDataToReport: (NSString*) json
            completionHandler: (void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;
@end
