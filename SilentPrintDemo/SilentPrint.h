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

@optional
-(void)onPrintFileComplete: (int) fileIndex withJob: (NSString*) jobName;
@end

//--------------------

@interface SilentPrint : NSObject <UIPrintInteractionControllerDelegate>

@property(nonatomic, strong) UIPrinter* selectedPrinter;
@property(nonatomic, weak) id<SilentPrintDelegate> silentPrintDelegate;
@property(nonatomic, strong) NSArray* filePaths;


+(SilentPrint*) getSingleton;

-(void)configureSilentPrint:(CGRect) rect
                     inView:(UIView*) view
                 completion:(void (^)(void))completionBlock;


//Print multiple file sequentially


-(void) printBatch:(NSArray *)filePaths;

//Print single file
-(void) printFile: (NSString*)filePath
           silent: (Boolean) silent
       onComplete: (void (^)(void)) complete;

-(void) printFile: (int)fileIndex;;

@end
