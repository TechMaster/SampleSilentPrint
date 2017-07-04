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
#define tempResizedImageFolder @"/resizedImages/"
@implementation UIImage (Utils)


NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

+(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    
    return randomString;
}

/*
 * Create folder resizedImages in temporary folder. Then generate scaled images to this folder.
 * If there are resized images from previous run then remove all of them
 */
+ (void) initTempResizedImageFolder {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString* fullPathToResizedImage = [NSTemporaryDirectory() stringByAppendingPathComponent:tempResizedImageFolder];
   
    NSError* err = nil;
    BOOL isDir;
    BOOL exists = [defaultManager fileExistsAtPath:fullPathToResizedImage
                                       isDirectory:&isDir];
    if (exists) {
        /* file exists */
        if (isDir) {
            /* folder exists then delete all files in folder */
            NSDirectoryEnumerator* en = [defaultManager enumeratorAtPath:fullPathToResizedImage];
            
            BOOL result;
            
            NSString* file;
            while (file = [en nextObject]) {
                result = [defaultManager removeItemAtPath:[fullPathToResizedImage stringByAppendingPathComponent:file]
                                                    error:&err];
                if (!result && err) {
                    NSLog(@"Failed to delete files: %@", err);
                }
            }
        }
    } else {
        /* folder does not exist */
        [defaultManager createDirectoryAtPath: fullPathToResizedImage
                  withIntermediateDirectories: YES
                                   attributes: nil
                                        error: nil];

    }
   
}
/*
 * Resize image to smaller size
 * return NSString* path to newly resized images in temporary directory/scaledimages/
 */
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
    
    //NSString* randomOutputFileName = [NSString stringWithFormat:@"%@-%@", [self randomStringWithLength:6] , [fullInputPath lastPathComponent]];
    
    NSString* fullPathToResizedImage = [NSTemporaryDirectory() stringByAppendingPathComponent:tempResizedImageFolder];
    
    NSURL *fileURLInTempFolder = [NSURL fileURLWithPath:[fullPathToResizedImage stringByAppendingPathComponent: [fullInputPath lastPathComponent]]];
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
