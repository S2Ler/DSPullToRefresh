//
//  DSPullToRefreshViewSimple
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/9/12.

#import <Foundation/Foundation.h>
#import "DSPullToRefreshView.h"


@interface DSPullToRefreshViewSimple: UIView<DSPullToRefreshView>
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

@end
