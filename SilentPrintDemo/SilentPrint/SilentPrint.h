//
//  SilentPrint.h
//  SilentPrintDemo
//
//  Created by cuong on 6/26/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintJob.h"
#import "NSMutableArray+Queue.h"  //Use queue data structure to store file path, UIView or NSData to be printed

#define PRINT_SUCCESS               0
#define PRINTER_IS_NOT_SELECTED     100
#define PRINTER_IS_OFFLINE          150
#define CANNOT_PRINT_ITEM           200
#define USER_CANCEL_PRINT           250


@protocol SilentPrintDelegate
-(void)onSilentPrintError: (NSError*) error;
-(void)onPrintJobCallback: (NSString*) jobName
                withError: (NSUInteger) errorCode;

@optional
-(void)tryToContactPrinter: (UIPrinter*) printer;



@end
//--------------
@interface SilentPrint : NSObject <UIPrintInteractionControllerDelegate>
@property(nonatomic, strong) UIPrinter* selectedPrinter;
@property(nonatomic, strong) id<SilentPrintDelegate> silentPrintDelegate;

@property(nonatomic, strong) NSMutableArray* printQueue;  //printQueue will replace filePaths
//printQueue will support file path, NSData and UIView

@property(nonatomic, assign) BOOL printInProgress;   //true when printNextJob is running
@property(nonatomic, strong) PrintJob* dequeuePrintJob;       //Dequeue print job in printing process
@property(nonatomic, assign) NSUInteger lastErrorCode;        //When we enqueue multiple jobs to print queue, if printer is offline or not-selected, same error happens repeatedly. We use lastErrorCode to prevent raise same error repeatedly.


+(SilentPrint*) getSingleton;


-(void)configureSilentPrint:(CGRect) rect
                     inView:(UIView*) view
        orFromBarButtonitem:(UIBarButtonItem*) barButtonItem
                 completion:(void (^)(void))completionBlock;

/*
 items is array that may contains filePath, NSData or UIView content
 items will be append to current printing queue
 */
-(void) printAJob: (PrintJob*) job;

-(void) printJobs: (NSArray *) jobs;

//Retry previous command after configure printer or reselect new printer
-(void) retryPrint;
@end
