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
-(void)tryToContactPrinter: (UIPrinter*) printer;
-(void)onPrintFileComplete: (int) fileIndex withJob: (NSString*) jobName;
-(void)onPrintBatchComplete: (int) success andFail: (int) fail;
@end

//--------------------

@interface SilentPrint : NSObject //<UIPrintInteractionControllerDelegate>

@property(nonatomic, strong) UIPrinter* selectedPrinter;
@property(nonatomic, weak) id<SilentPrintDelegate> silentPrintDelegate;
@property(nonatomic, strong) NSArray* filePaths;
@property(nonatomic, assign) Boolean printInProgress;  //True when SilentPrint is sending files to printer
@property(nonatomic, assign) int numberPrintSuccess;  //Number of successful printing job in a batch printing
@property(nonatomic, assign) int numberPrintFail; //Number of fail printing job in a batch printing
//@property(nonatomic, weak) id<UIPrintInteractionControllerDelegate> printInteractionControllerDelegate;



+(SilentPrint*) getSingleton;

-(void)configureSilentPrint:(CGRect) rect
                     inView:(UIView*) view
                 completion:(void (^)(void))completionBlock;


//Print multiple file sequentially. If SilentPrint is in printing, append filePaths to existing filePaths
-(void) printBatch:(NSArray *)filePaths;

//Print single file
-(void) printFile: (NSString*)filePath
           silent: (Boolean) silent
       onComplete: (void (^)(void)) complete;

-(void) printFile: (int)fileIndex;;

@end
