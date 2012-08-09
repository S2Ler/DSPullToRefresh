//
//  DSPullToRefreshControllerDelegate
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/9/12.

@class DSPullToRefreshController;

@protocol DSPullToRefreshControllerDelegate<NSObject, UITableViewDelegate>
- (NSOperation *)pullToRefreshControllerDidRequestedWorkOperation:(DSPullToRefreshController *)theController;
@end
