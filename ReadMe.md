# SilentPrint Library

## Introduction

SilentPrint is wrapper library that uses Apple AirPrint SDK to print single file or multiple files.
It allows user to choose either print interactively with pop up preview dialog or print silently.

This library has following files:
1. SilentPrint.h, .m : main logic of SilentPrint
2. PrintJob.h, .m: represents a single unit of print job: a file to print specified by NSString* or NSURL*, content of UIView, UIImage, NSData
3. NSMutableArray+Queue.h, .m: extend NSMutableArray to become FIFO queue

SilentPrint is a singleton class. It communicates error, printing progress to the app through SilentPrintDelegate.

[The sample app](https://github.com/TechMaster/SampleSilentPrint) demonstrates all features of SilentPrint. Take time to play sample app and read sample code, you will understand.

## How to use

Since SilentPrint is singleton object, we don't need to use strong property points to it.When you need to use it in code, just use ```[SilentPrint getSingleton]``` or assign it to self.silentPrint property

```objective-c
@property (weak, nonatomic) SilentPrint* silentPrint;

@interface ViewController : UIViewController <SilentPrintDelegate>

self.silentPrint = [SilentPrint getSingleton];
self.silentPrint.silentPrintDelegate = self;
```
Continue to implement two required methods in SilentPrintDelegate protocol:
```objective-c
-(void)onSilentPrintError: (NSError*) error;
-(void)onPrintJobCallback: (NSString*) jobName
                withError: (NSUInteger) errorCode;
```

### Error code and error reason
-   0: print success
- 100: printer is not selected
- 150: printer is offline
- 200: cannot print file URL
- 250: user cancel or print fails

onSilentPrintError will be called when error code = 100 or 150

onPrintJobCallBack will be called :
- App sends file sucessfully to AirPrint (errorCode = 0)
- file to print is invalid or cannot print file URL (error code = 200)
- user cancels print (errorCode = 250)


## How to report bug and request to improve
Create issue in github and assign to me




# Updates
## Jun 28th 2017
Rewrite SilentPrint: replace NSArray filePaths by NSMuttableArray+Queue printQueue

## Jun 20th 2017
Replace Mustache template engine by Vue.js template engine
## May 23rd 2017
- Update report

## May 18th 2017
- Use Mustache, Javascript, HTML, CSS to generate PDF. This approach is better than coding Objective-C
- Fix margin problem

## May 14th 2017
- Add PDF Generation library
- Demo print to PDF at paper size Letter and A4. AirPrint always uses default Letter.

## May 6th 2017
- Popup printer configuration when user has not yet selected printer or printer is offline
- Resume printing after printer is selected. See SilentPrint.retryPrint method.
- Add new property SilentPrint.pendingFileIndex to store the last fileIndex
- Fix random crash in printFile:inSilent just add ```if (filePath)``` to validate filePath
```objective-c
-(void) printFile: (NSString*) filePath
         inSilent: (Boolean) silent{
    if (filePath) {
        [self printBatch:@[filePath] andShowDialog:!silent];
    }
}
```

## May 4th 2017
- Simplify printing logic: merge print single file with print batch
- Support printing txt, csv, log file by adding this function
```objective-c
(UIPrintFormatter*) generatePrintFormater: (NSURL*) fileURL {
NSString* fileExtension = [fileURL pathExtension];
```

## May 3rd 2017
In method 
```objective-c
-(void) printFile: (NSString*)filePath
           silent: (Boolean) silent
       onComplete: (void (^)(void)) complete;
```
add logic call 
```
[UIPrinter contactPrinter:^(BOOL available)]
```
to test if printer is online.

In protocol SilentPrintDelegate, add method ```-(void)tryToContactPrinter: (UIPrinter*) printer;```
Cosumer app will know when SilentPrint object tries to contact to printer

Some times, when printer is offline but [UIPrinter contactPrinter:^(BOOL available)] still return True. 
[See my demo video](https://www.youtube.com/watch?v=8hA0YJqR6e0)


## May 2nd 2017

1. If user prints a batch, "Print is not Selected” is sent to user as error popup/notification.
2. Print resumes when encountering bad URl file
3. Add method to SilentPrintDelegate
```objective-c
-(void)onPrintBatchComplete: (int) success andFail: (int) fail;
```
4. Add following properties to class SilentPrint
```objective-c
@property(nonatomic, assign) Boolean printInProgress;  //True when SilentPrint is sending files to printer
@property(nonatomic, assign) int numberPrintSuccess;
@property(nonatomic, assign) int numberPrintFail;
```
5. Allow app to starts multiple batch printing job at same time. Silent Print will append new batch to printing batch.
```objective-c
-(void) printBatch:(NSArray *)filePaths
{
    if (self.printInProgress) { //If silent print is printing then append
        NSLock *theLock=[NSLock new];
        [theLock lock];

        //Check if printing is in progress, then append array !
        NSArray* arrayAfterAppend = [self.filePaths arrayByAddingObjectsFromArray:filePaths];
        self.filePaths = arrayAfterAppend;
        [theLock unlock];

    } else {
        self.printInProgress = true;
        self.numberPrintFail = 0;
        self.numberPrintSuccess = 0;
        self.filePaths = filePaths;
        [self printFile:0];
    }
}
```
# How to use
1. Adopt SilentPrintDelegate protocol
  ```objective-c
  #import <UIKit/UIKit.h>
  #import "SilentPrint.h"
  @interface PrintBatch : UIViewController <SilentPrintDelegate>
  @end
  ```
2. Send multiple files to printers using SilentPrint
  ```objective-c
   SilentPrint* silentPrint = [SilentPrint getSingleton];
   silentPrint.silentPrintDelegate = self;
   NSArray *filePaths = @[
                          [[NSBundle mainBundle] pathForResource:@"koi" ofType:@"jpg"],
                          @"NoExistFile.jpg",
                          [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"],
                          [[NSBundle mainBundle] pathForResource:@"1" ofType:@"pdf"],
                          [[NSBundle mainBundle] pathForResource:@"3" ofType:@"html"]
                          ];

  self.printingProgress.progress = 0.0;
  [silentPrint printBatch: filePaths];
  ```



