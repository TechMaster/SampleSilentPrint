//
//  PaperConfig.m
//  SilentPrintDemo
//
//  Created by cuong on 5/13/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "PaperConfig.h"

@implementation PaperConfig
- (id) initPaperType: (PaperType) paperType
         orientation: (PaperOrientation) paperOrientation
           marginTop: (float) marginTop
        marginBottom: (float) marginBottom
         marginRight: (float) marginRight
          marginLeft: (float)marginLeft {
    if( self = [super init] )
    {
        self.paperType = paperType;
        self.paperOrientation = paperOrientation;
        self.marginTop = marginTop;
        self.marginBottom = marginBottom;
        self.marginRight = marginRight;
        self.marginLeft = marginLeft;
    }
    
    return self;
}
@end
