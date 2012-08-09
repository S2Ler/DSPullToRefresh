//
//  DSPullToRefreshController
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/6/12.

#import <Foundation/Foundation.h>

@protocol DSPullToRefreshControllerDelegate;
@protocol DSPullToRefreshView;


@interface DSPullToRefreshController: NSObject
/** REQUIRED */
@property (nonatomic, weak) IBOutlet id<DSPullToRefreshControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) Class pullToRefreshViewClass;

@property (nonatomic, strong, readonly) UIView<DSPullToRefreshView> *refreshView;
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
