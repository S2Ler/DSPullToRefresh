//
//  DSPullToRefreshController
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/6/12.

#import <Foundation/Foundation.h>

@protocol DSPullToRefreshControllerDelegate;
@protocol DSPullToRefreshView;


@interface DSPullToRefreshController: NSObject
@property (nonatomic, weak) id<DSPullToRefreshControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Class pullToRefreshViewClass;

@property (nonatomic, strong, readonly) UIView<DSPullToRefreshView> *refreshView;
- (void)createViewHierarchy;


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate;

@end
