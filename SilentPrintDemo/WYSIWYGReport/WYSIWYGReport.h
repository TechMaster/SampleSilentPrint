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



@property (nonatomic, readonly) NSString* _Nonnull reportTemplate;
@property (nonatomic, strong) WKWebView* _Nonnull webView;
@property (nonatomic, assign) BOOL enableInteraction; //Allow user select image or edit text

-(id _Nonnull ) initWithReportTemplate: (NSString*_Nonnull)  report;
-(void) applyJSONDataToReport: (NSString*_Nonnull) json
            completionHandler: (void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;
@end
