//
//  PDFPageRenderer.h
//  SilentPrintDemo
//
//  Created by cuong on 5/12/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFPageRenderer : UIPrintPageRenderer
- (NSData*) printToPDF;
@end
