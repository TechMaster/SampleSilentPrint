//
//  SilentPrint.h
//  SilentPrintDemo
//
//  Created by cuong on 4/27/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PRINTER_IS_NOT_SELECTED     100
#define PRINTER_IS_OFFLINE          150
#define CANNOT_PRINT_FILE_URL       200
#define USER_CANCEL_PRINT           250

#define NO_PENDING_FILE_PRINT       -1

@protocol SilentPrintDelegate

-(void)onSilentPrintError: (NSError*) error;
@optional
-(void)tryToContactPrinter: (UIPrinter*) printer;
-(void)onPrintFileComplete: (int) fileIndex withJob: (NSString*) jobName;
-(void)onPrintBatchComplete: (int) success andFail: (int) fail;
@end

//--------------------

@interface SilentPrint : NSObject <UIPrintInteractionControllerDelegate>


@property(nonatomic, strong) UIPrinter* selectedPrinter;
@property(nonatomic, weak) id<SilentPrintDelegate> silentPrintDelegate;
@property(nonatomic, strong) NSArray* filePaths;
@property(nonatomic, assign) Boolean printInProgress;  //True when SilentPrint is sending files to printer
@property(nonatomic, assign) int numberPrintSuccess;  //Number of successful printing job in a batch printing
@property(nonatomic, assign) int numberPrintFail; //Number of fail printing job in a batch printing
@property(nonatomic, assign) int pendingFileIndex; //File index of print batch




+(SilentPrint*) getSingleton;

-(void)configureSilentPrint:(CGRect) rect
                     inView:(UIView*) view
                 completion:(void (^)(void))completionBlock;


//Print multiple file sequentially. If SilentPrint is in printing, append filePaths to existing filePaths
-(void) printBatch: (NSArray *) filePaths;

//Prin a single file, in fact we turn to printBatch with filePaths has only one item
-(void) printFile: (NSString*) filePath
         inSilent: (Boolean) silent;

//Print a file item in silentPrint.filePaths array
-(void) printFile: (int) fileIndex
    andShowDialog: (Boolean) show;

//Retry previous command after configure printer or reselect new printer
-(void) retryPrint;

@end
