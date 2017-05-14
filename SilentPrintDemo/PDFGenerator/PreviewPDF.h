//
//  PreviewPDF.h
//  SlientPrint
//
//  Created by Tuuu on 10/26/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PreviewPDFDelegate
-(void)showError:(NSString *)error;
@end
@interface PreviewPDF : UIViewController
-(void)previewPDFReport:(NSDictionary *)components
             andSubView:(UIView *)subView;
@property (nonatomic, assign) CGFloat leftViewWidth;
@property (nonatomic, assign) id<PreviewPDFDelegate> delegate;

@end
