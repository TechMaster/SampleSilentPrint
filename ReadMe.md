# New silent print library
# Introduction

SilentPrint is wrapper library that uses Apple AirPrint SDK to print single file or multiple files.
It allows user to choose either print interactively with pop up preview dialog or print silently.

This library has only two files: SilentPrint.h and SilentPrint.m. It is a singleton class. It communicates error, printing progress to the app through SilentPrintDelegate.
The sample app demonstrates all features of SilentPrint. Take time to play sample app and read sample code, you will understand.

If you encounter bug, please report to cuong@techmaster.vn, I will fix and push back to Github.

[Check this video](https://youtu.be/fm1cd00glt8)
## Error code and error reason

- 100: printer is not selected
- 150: printer is offline
- 200: cannot print file URL
- 250: user cancel or print fails

# Updates
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



