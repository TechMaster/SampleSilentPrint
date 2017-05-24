//
//  ScaleImage.m
//  SilentPrintDemo
//
//  Created by cuong on 5/24/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "ScaleImage.h"
#import "UIImage+Utils.h"
@interface ScaleImage ()

@end

@implementation ScaleImage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSString* inputPath = [[NSBundle mainBundle] pathForResource:@"01" ofType:@"jpg"];
    NSString* outputPath = [UIImage scaleDownImage:inputPath maxWidth: 262];
    UIImage* image = [UIImage imageWithContentsOfFile:outputPath];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(20, 20, image.size.width, image.size.height);
    [self.view addSubview:imageView];
    
}


@end
