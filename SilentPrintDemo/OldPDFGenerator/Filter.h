//
//  Filter.h
//  RebuildLib
//
//  Created by Tuuu on 11/3/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject
-(NSDictionary *)replaceValuesToKeys:(NSDictionary *)data;
-(NSString *)addRawValuesToHTML:(NSDictionary *)data htmlString:(NSString *)html;
-(NSDictionary *) convertArraySelectedImagesToDictionary:(NSArray *)images;
@end
