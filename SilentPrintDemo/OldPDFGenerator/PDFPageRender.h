//
//  PDFPageRender.h
//  RebuildLib
//
//  Created by Tuuu on 11/3/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ConstantKeys.h"
@interface PDFPageRender : UIPrintPageRenderer;
@property (nonatomic) BOOL singleDigit;
@property (nonatomic, copy) NSString *headerText;
@property (nonatomic, copy) NSString *footerText;
-(NSData*) printToPDF:(UIView*)aView;
#define HEADER_FONT_SIZE 14
#define HEADER_TOP_PADDING 5
#define HEADER_BOTTOM_PADDING 10
#define HEADER_RIGHT_PADDING 5
#define HEADER_LEFT_PADDING 5

#define FOOTER_FONT_SIZE 12
#define FOOTER_TOP_PADDING 10
#define FOOTER_BOTTOM_PADDING 5
#define FOOTER_RIGHT_PADDING 5
#define FOOTER_LEFT_PADDING 5

@end
