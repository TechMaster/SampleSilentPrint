//
//  Filter.m
//  RebuildLib
//
//  Created by Tuuu on 11/3/16.
//  Copyright © 2016 Tuuu. All rights reserved.
//

#import "Filter.h"
#import "ConstantKeys.h"
@implementation Filter
-(NSDictionary *)replaceValuesToKeys:(NSDictionary *)data
{
    NSMutableDictionary *subData = [NSMutableDictionary dictionaryWithDictionary:data];
    for (NSString *key in data.allKeys) {
        if(![subData[key]  isEqual: @""])
        {
            subData[key] = key;
        }
        
    }
    return subData;
    
}
-(NSString *)addRawValuesToHTML:(NSDictionary *)data htmlString:(NSString *)html
{
    NSString *htmlString = html;
    for (NSString *key in data.allKeys)
    {
        htmlString = [htmlString stringByReplacingOccurrencesOfString:key withString:data[key]];
    }
    return htmlString;
}
-(NSDictionary *) convertArraySelectedImagesToDictionary:(NSArray *)images
{
    NSMutableArray *imagesToDic = [NSMutableArray array];
    
    for (NSString *imgName in images)
    {
        [imagesToDic addObject:[NSDictionary
                                dictionaryWithObjectsAndKeys:imgName, KImageName, nil]];
    }
    return [NSDictionary dictionaryWithObjectsAndKeys: imagesToDic, kSelectedImages, nil];
}
@end
