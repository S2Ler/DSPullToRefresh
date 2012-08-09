//
//  DSPullToRefreshControllerDelegate
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/9/12.

#import "DSPullToRefreshViewsPositions.h"

@class DSPullToRefreshController;

@protocol DSPullToRefreshControllerDelegate<NSObject, UITableViewDelegate>
- (NSOperation *)pullToRefreshControllerDidRequestedWorkOperation:(DSPullToRefreshController *)theController
                                                  forViewPosition:(DSPullToRefreshViewPosition)thePosition;
@end
