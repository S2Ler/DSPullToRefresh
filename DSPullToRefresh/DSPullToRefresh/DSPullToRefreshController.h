//
//  DSPullToRefreshController
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/6/12.

#import <Foundation/Foundation.h>

@protocol DSPullToRefreshControllerDelegate;
@protocol DSPullToRefreshView;

typedef enum {
  DSPullToRefreshViewPositionTop = 1,
  DSPullToRefreshViewPositionRight = 1 << 1,
  DSPullToRefreshViewPositionBottom = 1 << 2,
  DSPullToRefreshViewPositionLeft = 1 << 3
} DSPullToRefreshViewPosition;

@interface DSPullToRefreshController: NSObject
/** REQUIRED */
@property (nonatomic, weak) IBOutlet id<DSPullToRefreshControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) Class pullToRefreshViewClassHorizontal;
@property (nonatomic, strong) Class pullToRefreshViewClassVertical;

@property (nonatomic, strong, readonly) UIView<DSPullToRefreshView> *refreshViewLeft;
@property (nonatomic, strong, readonly) UIView<DSPullToRefreshView> *refreshViewRight;
@property (nonatomic, strong, readonly) UIView<DSPullToRefreshView> *refreshViewBottom;
@property (nonatomic, strong, readonly) UIView<DSPullToRefreshView> *refreshViewTop;

/** DSPullToRefreshViewPositionLeft | DSPullToRefreshViewPositionRight - is possible */
@property (nonatomic, assign) DSPullToRefreshViewPosition viewsPositions;

- (void)createViewHierarchy;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate;

/** Paste in your UITableViewDelegate and adjust to your needs.
*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [[self pullToRefreshController] scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [[self pullToRefreshController] scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
  [[self pullToRefreshController] scrollViewDidEndDragging:scrollView
                                            willDecelerate:decelerate];
}
*/
@end
