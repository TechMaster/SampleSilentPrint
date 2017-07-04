
//
//  Header.h
//  SilentPrintDemo
//
//  Created by cuong on 5/24/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#ifndef Header_h
#define Header_h
@interface UIImage (Utils)

+ (void) initTempResizedImageFolder;

//Resize photo then save it to temporary folder
+ (NSString*_Nullable) scaleDownImage: (NSString*_Nonnull) fullInputPath
maxWidth: (float) maxWidth;

- (NSString*_Nullable) scaleTo: (float) maxWidth;
@end
#endif /* Header_h */
