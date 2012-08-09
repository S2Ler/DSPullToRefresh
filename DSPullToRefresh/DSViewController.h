//
//  DSViewController.h
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/5/12.
//  Copyright (c) 2012 Diejmon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPullToRefreshViewController.h"
#import "DSPullToRefreshViewControllerDelegate.h"

@interface DSViewController : DSPullToRefreshViewController<UITableViewDataSource, DSPullToRefreshViewControllerDelegate>

@end
