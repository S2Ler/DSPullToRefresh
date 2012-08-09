//
//  DSPullToRefreshViewControllerDelegate
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/9/12.

@protocol DSPullToRefreshViewControllerDelegate<NSObject>
- (NSOperation *)pullToRefreshViewControllerDidRequestedWorkOperation:(DSPullToRefreshViewController *)theController;
@end
