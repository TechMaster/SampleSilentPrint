//
//  PaperConfig.h
//  SilentPrintDemo
//
//  Created by cuong on 5/13/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PaperTypeA4,
    PaperTypeLetter
} PaperType;

typedef enum {
    PaperOrientationPortrait,
    PaperOrientationLandscape
} PaperOrientation;

@interface PaperConfig : NSObject
@property(nonatomic, assign) PaperType paperType;
@property(nonatomic, assign) PaperOrientation paperOrientation;
@property(nonatomic, assign) float marginTop;
@property(nonatomic, assign) float marginBottom;
@property(nonatomic, assign) float marginRight;
@property(nonatomic, assign) float marginLeft;

- (id) initPaperType: (PaperType) paperType
         orientation: (PaperOrientation) paperOrientation
           marginTop: (float) marginTop
        marginBottom: (float) marginBottom
         marginRight: (float) marginRight
          marginLeft: (float)marginLeft;

@end
