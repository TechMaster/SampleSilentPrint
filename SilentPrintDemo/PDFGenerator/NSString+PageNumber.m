//
//  NSString+PageNumber.m
//  SlientPrint
//
//  Created by Tuuu on 11/7/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

#import "NSString+PageNumber.h"

@implementation NSString (PageNumber)
+ (NSString *)numberOfPageWithFormat:(int)number
                         totalNumber:(int)totalNumber
                     isSingleDigital:(BOOL)singleDigital

{
    return singleDigital == true ? [NSString stringWithFormat:@"%d", number] : [NSString stringWithFormat:@"%@ %d of %d", NSLocalizedString(@"Page", nil), number, totalNumber];
}
@end
