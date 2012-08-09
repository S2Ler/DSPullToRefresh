//
//  DSPullToRefreshViewController
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/6/12.

#import <Foundation/Foundation.h>

@protocol DSPullToRefreshViewControllerDelegate;


@interface DSPullToRefreshViewController: UIViewController<UITableViewDelegate>
@property (nonatomic, weak) id<DSPullToRefreshViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Class pullToRefreshViewClass;
@end
