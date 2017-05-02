# New silent print library

[Check this video](https://youtu.be/fm1cd00glt8)

# Updates

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

