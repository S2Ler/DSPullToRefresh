//
//  DSAppDelegate.h
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/5/12.
//  Copyright (c) 2012 Diejmon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSViewController;

@interface DSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DSViewController *viewController;

@end
