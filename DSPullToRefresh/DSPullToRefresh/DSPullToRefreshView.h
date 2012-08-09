//
//  DSPullToRefreshView
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/6/12.

typedef enum {
  DSPullToRefreshViewModeAutoActivation,
  DSPullToRefreshViewModeReleaseToActivate
} DSPullToRefreshViewMode;

typedef void (^ds_finish_handler)(BOOL success);


/** UIView */
@protocol DSPullToRefreshView<NSObject>
@property (nonatomic, assign, readonly) DSPullToRefreshViewMode mode; 

/** Valid only in DSPullToRefreshViewModeAutoActivation */
@property (nonatomic, assign, readonly) CGFloat heightForAutoActivation;

/** TODO: document */
@property (nonatomic, assign, readonly) CGFloat heightForActivation;

/** 0.0 to 1.0 */
@property (nonatomic, assign) CGFloat overScrollPercent;

- (id)init;

- (void)activateViewWithWorkOperation:(NSOperation *)theWorkOperation
                    completionHandler:(ds_finish_handler)theHandler;
@end
