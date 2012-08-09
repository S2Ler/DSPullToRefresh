//
//  DSViewController.h
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/5/12.
//  Copyright (c) 2012 Diejmon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPullToRefreshController.h"
#import "DSPullToRefreshControllerDelegate.h"

@interface DSViewController : UIViewController<UITableViewDataSource, DSPullToRefreshControllerDelegate>
@property (nonatomic, strong) IBOutlet DSPullToRefreshController *pullToRefreshController;
@end
