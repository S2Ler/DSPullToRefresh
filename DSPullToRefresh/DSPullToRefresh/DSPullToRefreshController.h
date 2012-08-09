//
//  DSPullToRefreshController
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/6/12.

#import <Foundation/Foundation.h>

@protocol DSPullToRefreshControllerDelegate;


@interface DSPullToRefreshController: NSObject<UITableViewDelegate>
@property (nonatomic, weak) id<DSPullToRefreshControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Class pullToRefreshViewClass;

- (void)createViewHierarchy;
@end
