//
//  PrintItem.h
//  SilentPrintDemo
//  Represent a print job:
//  Created by cuong on 6/27/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrintJob : NSObject
@property (nonatomic, strong) id item;  //item can be NSString, NSURL, NSData, UImage, UIView
@property (nonatomic, assign) BOOL show; //Show print dialog, user may change configure
@property (nonatomic, strong) NSString* name; //Unique name for job, developer should assign to differentiate

//rect, view, barbutton must be set when show is True and device is iPad. These properties used to present printing dialog in interactive mode
@property(nonatomic, assign) CGRect rect;  //rect and view go together
@property(nonatomic, weak) UIView* view;
@property(nonatomic, weak) UIBarButtonItem* barButton;

//If device is iPhone, show is true, rect, view, barbutton will be nil

//This init method is used for iPhone device in silent and interactive modes and iPad in silent mode (show = false)
- (instancetype) init: (id) item
             withShow: (BOOL) show;

//This init method is used for iPad in interactive mode
- (instancetype) init: (id) item
             withRect: (CGRect) rect
             withView: (UIView*) view
        withBarButton: (UIBarButtonItem*) barButton;
@end
