//
//  SilentPrint.m
//  SilentPrintDemo
//
//  Created by cuong on 6/26/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "SilentPrint.h"

@implementation SilentPrint

+(SilentPrint*) getSingleton
{
    static SilentPrint *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [SilentPrint new];
        _sharedInstance.printInProgress = false;
        _sharedInstance.dequeuePrintJob = nil;
        _sharedInstance.printQueue = [NSMutableArray new];
        _sharedInstance.lastErrorCode = 0;
        
    });
    return _sharedInstance;
}

/* Raise error to outter application
 */
-(void)raiseError: (NSInteger) errorCode {
    //make sure delegate is not nil
    if (!self.silentPrintDelegate) return;
    
    NSString* message = nil;
    switch (errorCode) {
        case PRINTER_IS_NOT_SELECTED:
            if (errorCode == self.lastErrorCode) return;  //Don't raise same system error repeatedly
            message = @"Printer is not selected";
            break;
        case PRINTER_IS_OFFLINE:
            if (errorCode == self.lastErrorCode) return;  //Don't raise same system error repeatedly
            message = @"Printer is offline";
            break;
        case CANNOT_PRINT_ITEM:
            message = @"Printer cannot print invalid item";
            break;
        case USER_CANCEL_PRINT:
            message = @"User cancels or print fails";
            break;
        default:
            message = @"Unknown error";
            break;
    }
    
    NSError* error = [NSError errorWithDomain: @"SilentPrint"
                                         code: errorCode
                                     userInfo: @{NSLocalizedDescriptionKey: message}
                      ];
    self.lastErrorCode = errorCode;
    [self.silentPrintDelegate onSilentPrintError:error];
    
}

/*
 * Show printer configure dialog. This function supports both iPhone and iPad
 * if device is iPad, either view or barButtonItem must not be null at same time
 * if device is iPhone pass rect = CGRectZero, and nil to both view and barButtonItem parameters
 */
-(void)configureSilentPrint:(CGRect) rect
                     inView:(UIView*) view
        orFromBarButtonitem:(UIBarButtonItem*) barButtonItem
                 completion:(void (^)(void))completionBlock;
{
    //Declare a local variable point to block function that handles event user selects a printer
    void (^handleFunction) (UIPrinterPickerController *printerPickerController, BOOL didSelect, NSError *error) = ^(UIPrinterPickerController *printerPickerController, BOOL didSelect, NSError *error) {
        // error happens
        if (error && self.silentPrintDelegate) {
            [self.silentPrintDelegate onSilentPrintError:error];
        }
        // if printer is selected
        if (didSelect) {
            // assign selected printer to singleton
            self.selectedPrinter = printerPickerController.selectedPrinter;
            self.lastErrorCode = 0;
            completionBlock();
        } else {
            [self raiseError: PRINTER_IS_NOT_SELECTED];
            self.lastErrorCode = 0;
        }
        
    };
    
    UIPrinterPickerController *printerPicker = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )  //iPad device
    {
        if (view) {  //present printer picker controller from a rect in view of iPad device      
            [printerPicker presentFromRect: rect
                                    inView: view
                                  animated: TRUE
                         completionHandler: handleFunction];
        } else {  //present printer picker controller from a UIBarButtonItem of iPad device
            [printerPicker presentFromBarButtonItem: barButtonItem
                                           animated: TRUE
                                  completionHandler: handleFunction];
        }
    } else {  //iPhone device
        [printerPicker presentAnimated:TRUE completionHandler:^(UIPrinterPickerController * _Nonnull printerPickerController, BOOL userDidSelect, NSError * _Nullable error) {
            handleFunction(printerPickerController, userDidSelect, error);
        }];
    }
    
}

/*
 * Handle when [UIPrintInteractionController canPrintURL:fileURL] return false
 * support to print html, htm and txt, csv, log files
 */
-(UIPrintFormatter*) generatePrintFormater: (NSURL*) fileURL {
    NSString* fileExtension = [fileURL pathExtension];
    NSString* fileContent = [NSString stringWithContentsOfFile: fileURL.path
                                                      encoding: NSUTF8StringEncoding
                                                         error: NULL];
    UIPrintFormatter* printFormatter;
    
    if ([fileExtension isEqualToString:@"html"] || [fileExtension isEqualToString:@"htm"]) {
        printFormatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText: fileContent];  //Markup
        
    } else if ([fileExtension isEqualToString:@"txt"] ||
               [fileExtension isEqualToString:@"csv"] ||
               [fileExtension isEqualToString:@"log"] ) {
        printFormatter = [[UISimpleTextPrintFormatter alloc] initWithText: fileContent];  //Simple text
    } else {
        return nil;
    }
    
    printFormatter.perPageContentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0);
    return printFormatter;
}

#pragma mark - print function
/*
 Similar with printBatch, items is array that may contains filePath, NSData or UIView content
 items will be append to current printing queue
 */
-(void) printAJob: (PrintJob*) job {
    if (!job) return;
    
    [self.printQueue addObject:job];
    //if printing process is not yet running then start
    if (!self.printInProgress) {
        [self retryPrint];
    }

}

/*
 * Enqueue array of jobs to printQueue
 */
-(void) printJobs: (NSArray *) jobs {
    [self.printQueue addObjectsFromArray:jobs];
    //if printing process is not yet running then start
    if (!self.printInProgress) {
        [self retryPrint];
    }
}

//Retry previous command after configure printer or reselect new printer
-(void) retryPrint {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self printNextJob];
    });
}

/*  pass itemToPrint check if it can be printed or not
 modify printController
 */
- (BOOL) checkIfItemCanBePrint: (id) itemToPrint
           withPrintController: (UIPrintInteractionController*) printController{
    
    BOOL canItemPrinted = false;
    //convert NSString to NSURL then assign back to self.pendingPrintItem
    if ([itemToPrint isKindOfClass: [NSString class]]) {
        itemToPrint = [NSURL fileURLWithPath: itemToPrint];
    }
    
    //Check type of pendingPrintItem
    if ([itemToPrint isKindOfClass: [NSURL class]]) {
        
        //if file is printable then
        if ([UIPrintInteractionController canPrintURL:itemToPrint]) {
            canItemPrinted = true;
            printController.printingItem = itemToPrint;
        } else {
            UIPrintFormatter*  printFormatter = [self generatePrintFormater:itemToPrint];
            if (printFormatter) {
                canItemPrinted = true;
                printController.printFormatter = printFormatter;
            }
        }
    } else if ([itemToPrint isKindOfClass: [NSData class]]) {
        if ([UIPrintInteractionController canPrintData: itemToPrint]) {
            canItemPrinted = true;
            printController.printingItem = itemToPrint;
        }
    } else if ([itemToPrint isKindOfClass: [UIView class]]) {
        UIPrintFormatter* printFormatter = [itemToPrint viewPrintFormatter];
        canItemPrinted = true;
        printController.printFormatter = printFormatter;
        
    } else if ([itemToPrint isKindOfClass: [UIImage class]]) {
        canItemPrinted = true;
        printController.printingItem = itemToPrint;
    }
    
    return canItemPrinted;
}

/*
 * Return FALSE then stop process next print job
 * Return TRUE then process next print job
 */
- (BOOL) checkPrinterThenDequeuePrintJob {
    //If printer is not selected then raise error
    if (!self.selectedPrinter) {
        @synchronized (self) {
            self.printInProgress = false;
        }
        [self raiseError: PRINTER_IS_NOT_SELECTED];
        return FALSE;
    }
    
    //if there is no dequeuePrintJob then dequeue to get one
    if (self.dequeuePrintJob == nil) {
        @synchronized (self) {
            self.dequeuePrintJob = [self.printQueue dequeue];
        }
        
        //if dequeue item is nil again then we conclude print queue is empty
        if (self.dequeuePrintJob == nil) {
            @synchronized (self) {
                self.printInProgress = false;  //printing is done
            }
            return FALSE;
        }
    }
    
    return TRUE;
}
/*
 * Dequeue a job from printQueue then print
 * if there is an error: printer is not selected, printer is offline, then retry
 *
 */
-(void) printNextJob {
    self.printInProgress =true;
    
    if (![self checkPrinterThenDequeuePrintJob]) {
        return;
    }
    
    
    UIPrintInteractionController* printController = [UIPrintInteractionController sharedPrintController];
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printController.printInfo = printInfo;
    printController.delegate = self;
    
    id itemToPrint = self.dequeuePrintJob.item;
    
    BOOL canItemPrinted = [self checkIfItemCanBePrint:itemToPrint
                                  withPrintController:printController];
    
    
    //If item cannot be printed
    if (!canItemPrinted) {
        //[self raiseError: CANNOT_PRINT_ITEM];
        
        [self.silentPrintDelegate onPrintJobCallback:self.dequeuePrintJob.name
                                           withError:CANNOT_PRINT_ITEM];
        @synchronized (self) {
            self.dequeuePrintJob = nil;
        }
        //Dequeue next job to print
        dispatch_async(dispatch_get_main_queue(), ^{
            [self printNextJob];
        });
        return;
    }
    
    //Before actually print item, try to contact printer
    if (self.silentPrintDelegate && [(id)self.silentPrintDelegate respondsToSelector:@selector(tryToContactPrinter:)]) {
        [self.silentPrintDelegate tryToContactPrinter:self.selectedPrinter];
    }
    
    [self.selectedPrinter contactPrinter:^(BOOL available) {
        if (!available) {//Printer is not available
            @synchronized (self) {
                self.printInProgress = false;
            }
            [self raiseError: PRINTER_IS_OFFLINE];
            return;
        }
        //Printer is available
        self.lastErrorCode = 0;
        
        //Declare printCallBack as block function
        void (^printCallBack)(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) = ^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
            if (error) {
                @synchronized (self) {
                    self.printInProgress = false;
                }
                [self.silentPrintDelegate onSilentPrintError:error];
            } else if (!completed) { //user cancel this print job
                @synchronized (self) {
                    self.printInProgress = false;
                    self.dequeuePrintJob = nil;  //Set to nil ready for next job
                }
              
                [self.silentPrintDelegate onPrintJobCallback:self.dequeuePrintJob.name withError:USER_CANCEL_PRINT];
                
            } else {  //Print interactively complete
                [self.silentPrintDelegate onPrintJobCallback:self.dequeuePrintJob.name withError:PRINT_SUCCESS];
                @synchronized (self) {
                    self.dequeuePrintJob = nil;  //Set to nil ready for next job
                }
                //Print the next file in batch
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self printNextJob];
                });
                
            }
        };
        
        
        if (!self.dequeuePrintJob.show) {  //SILENT MODE
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [printController printToPrinter:self.selectedPrinter
                              completionHandler:printCallBack];
            });  //dispatch_async
            
        } else {  //INTERACTIVE MODE, self.dequeuePrintJob.show = true
            printController.showsPaperSelectionForLoadedPapers = YES;
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )  //iPad device
            {
                if (self.dequeuePrintJob.view) {  //present printer picker controller from a rect in view of iPad device
                    [printController presentFromRect: self.dequeuePrintJob.rect
                                              inView: self.dequeuePrintJob.view
                                            animated: TRUE
                                   completionHandler: printCallBack];
                    
                } else { //present printer picker controller from a UIBarButtonItem of iPad device
                    [printController presentFromBarButtonItem: self.dequeuePrintJob.barButton
                                                     animated: TRUE
                                            completionHandler: printCallBack];
                }
            } else {  //iPhone device
                [printController presentAnimated: TRUE
                               completionHandler: printCallBack];
            }
        }
        
    }];  //self.selectedPrinter contactPrinter
}


@end
