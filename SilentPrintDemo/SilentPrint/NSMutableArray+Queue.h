//
//  NSMutableArray+Queue.h
//  SilentPrintDemo
//
//  Created by cuong on 6/23/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Queue)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end
