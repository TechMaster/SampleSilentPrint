//
//  NSMutableArray+Queue.m
//  SilentPrintDemo
//
//  Created by cuong on 6/23/17.
//  Copyright © 2017 techmaster. All rights reserved.
//  Copy from https://stackoverflow.com/questions/817469/how-do-i-make-and-use-a-queue-in-objective-c

#import "NSMutableArray+Queue.h"

@implementation NSMutableArray (Queue)
// Queues are first-in-first-out, so we remove objects from the head
- (id) dequeue {
    id headObject =  self[0];//[self objectAtIndex:0];
    if (headObject != nil) {
        //[[headObject retain] autorelease]; // so it isn't dealloc'ed on remove
        [self removeObjectAtIndex:0];
    }
    return headObject;
}

// Add to the tail of the queue
- (void) enqueue:(id)anObject {
    //this method automatically adds to the end of the array
    [self addObject:anObject];    
}
@end
