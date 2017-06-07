//
//  ScaleImage.m
//  SilentPrintDemo
//
//  Created by cuong on 5/24/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import "UIImage+Utils.h"
/**
 Read this article carefully
 http://nshipster.com/image-resizing/
 */

@implementation UIImage (Utils)

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

+(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    
    return randomString;
}
+ (NSString*_Nullable) scaleDownImage: (NSString*_Nonnull) fullInputPath
                             maxWidth: (float) maxWidth {
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:fullInputPath], nil);
    if (!imageSource) return nil;
    
    
    CFDictionaryRef options = (__bridge CFDictionaryRef)@{
                                                          (id)kCGImageSourceThumbnailMaxPixelSize: @(maxWidth),
                                                          (id)kCGImageSourceCreateThumbnailFromImageIfAbsent: (id)kCFBooleanTrue,
                                                          (id)kCGImageSourceCreateThumbnailWithTransform: (id)kCFBooleanTrue
                                                          };
    
    CGImageRef cgScaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);
    
    UIImage *uiImage = [UIImage imageWithCGImage:cgScaledImage];
    NSData *jpgData = UIImageJPEGRepresentation(uiImage, 0.9f);
    
    NSString* randomOutputFileName = [NSString stringWithFormat:@"%@-%@", [self randomStringWithLength:6] , [fullInputPath lastPathComponent]];
    
    NSURL *fileURLInTempFolder = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: randomOutputFileName]];
    //----------
    [jpgData writeToURL:fileURLInTempFolder
             atomically:NO];
    
    CGImageRelease(cgScaledImage);
    CFRelease(imageSource);
    
    return [fileURLInTempFolder path];
    
}

- (NSString*_Nullable) scaleTo: (float) maxWidth {
    NSData *imageData = UIImagePNGRepresentation(self);
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (!imageSource) return nil;
    
    
    CFDictionaryRef options = (__bridge CFDictionaryRef)@{
                                                          (id)kCGImageSourceThumbnailMaxPixelSize: @(maxWidth),
                                                          (id)kCGImageSourceCreateThumbnailFromImageIfAbsent: (id)kCFBooleanTrue,
                                                          (id)kCGImageSourceCreateThumbnailWithTransform: (id)kCFBooleanTrue
                                                          };
    
    CGImageRef cgScaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);
    
    UIImage *uiImage = [UIImage imageWithCGImage:cgScaledImage];
    NSData *jpgData = UIImageJPEGRepresentation(uiImage, 0.9f);
    
    NSString* randomOutputFileName = [NSString stringWithFormat:@"%@.jpg", [UIImage randomStringWithLength:8]];
    
    NSURL *fileURLInTempFolder = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: randomOutputFileName]];
    //----------
    [jpgData writeToURL:fileURLInTempFolder
             atomically:NO];
    
    CGImageRelease(cgScaledImage);
    CFRelease(imageSource);
    
    return [fileURLInTempFolder path];
    
}

@end
