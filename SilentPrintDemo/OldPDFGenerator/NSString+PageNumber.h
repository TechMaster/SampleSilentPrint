//
//  NSString+PageNumber.h
//  SlientPrint
//
//  Created by Tuuu on 11/7/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PageNumber)
+ (NSString *)numberOfPageWithFormat:(int)number
                         totalNumber:(int)totalNumber
                     isSingleDigital:(BOOL)singleDigital;
@end
