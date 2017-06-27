//
//  PrintItem.m
//  SilentPrintDemo
//
//  Created by cuong on 6/27/17.
//  Copyright © 2017 techmaster. All rights reserved.
//

#import "PrintJob.h"

@implementation PrintJob

//This init method is for iPhone device or iPad device when show = false
- (instancetype) init: (id) item withShow: (BOOL) show {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && show == true) {
        show = false;  //should not accept this case, use 2nd init method when device = iPad and show = true
    }
    
    if (self = [super init]) {
        self.item = item;
        self.show = show;
        return self;
    } else {
        return nil;
    }
    
}
//This init method is for iPad only when show is true
- (instancetype) init: (id) item
             withRect: (CGRect) rect
             withView: (UIView*) view
        withBarButton: (UIBarButtonItem*) barButton {
    if (self = [super init]) {
        self.item = item;
        self.show = true;
    } else {
        return nil;
    }
    
    //(rect, view), barButton is mutually required when printing in interactive mode of iPad device
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (view) {
            self.view = view;
            self.rect = rect;
        } else if (barButton) {
            self.barButton = barButton;
        } else {
            self.show = false;  //force back to Silent mode when view, rect, barButton are nil
        }
    }
    
    return self;
    
}
@end
