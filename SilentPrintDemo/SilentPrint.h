//
//  SilentPrint.h
//  SilentPrintDemo
//
//  Created by cuong on 4/27/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SilentPrintDelegate

-(void)onSilentPrintError: (NSError*) error;

@end
//--------------------
@interface SilentPrint : NSObject <UIPrintInteractionControllerDelegate>

+(SilentPrint*) getSingleton;

@property(nonatomic, strong) UIPrinter* selectedPrinter;
@property(nonatomic, weak) id<SilentPrintDelegate> silentPrintDelegate;

-(void)configureSilentPrint:(CGRect) rect
                     inView:(UIView*) view
                 completion:(void (^)(void))completionBlock;

@end
