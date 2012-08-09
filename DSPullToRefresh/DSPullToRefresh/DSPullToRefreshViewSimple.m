//
//  DSPullToRefreshViewSimple
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/9/12.

#import "DSPullToRefreshViewSimple.h"
#import <QuartzCore/QuartzCore.h>

#define REFRESH_HEADER_HEIGHT 55.0

#pragma mark - private
@interface DSPullToRefreshViewSimple()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation DSPullToRefreshViewSimple
@synthesize overScrollPercent = _overScrollPercent;

#pragma mark - DSPullToRefreshView
- (DSPullToRefreshViewMode)mode
{
  return DSPullToRefreshViewModeReleaseToActivate;
}

- (CGFloat)heightForAutoActivation
{
  return 0.0;
}

- (CGFloat)heightForActivation
{
  return REFRESH_HEADER_HEIGHT;
}

- (void)setOverScrollPercent:(CGFloat)overScrollPercent
{
  _overScrollPercent = overScrollPercent;

  [self updateState];
}

- (id)init
{
  self = [super initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];

  if (self) {
    [self createViewHierarchy];
    _operationQueue = [[NSOperationQueue alloc] init];
  }

  return self;
}

- (void)createViewHierarchy
{
  _refreshHeaderView
    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
  _refreshHeaderView.backgroundColor = [UIColor clearColor];

  _refreshLabel = [[UILabel alloc]
                            initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
  _refreshLabel.backgroundColor = [UIColor clearColor];
  _refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
  _refreshLabel.textAlignment = UITextAlignmentCenter;

  _refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
  _refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                   (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                   27, 44);

  _refreshSpinner = [[UIActivityIndicatorView alloc]
                                              initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  _refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2),
                                     floorf((REFRESH_HEADER_HEIGHT - 20) / 2),
                                     20,
                                     20);
  _refreshSpinner.hidesWhenStopped = YES;

  [_refreshHeaderView addSubview:_refreshLabel];
  [_refreshHeaderView addSubview:_refreshArrow];
  [_refreshHeaderView addSubview:_refreshSpinner];
  [self addSubview:_refreshHeaderView];

  [self setupStrings];
}

- (void)activateViewWithWorkOperation:(NSOperation *)theWorkOperation
                    completionHandler:(ds_finish_handler)theHandler
{
  NSAssert(theWorkOperation, nil);
  [theWorkOperation setCompletionBlock:^
  {
    theHandler(YES);
    [self finished];
  }];

  [[self operationQueue] addOperation:theWorkOperation];
  [[self operationQueue] setSuspended:NO];
  [self updateState];
}

#pragma mark - state
- (void)finished
{
  [[self refreshLabel] setText:[self textPull]];
  [[self refreshArrow] setHidden:NO];
  [[self refreshSpinner] stopAnimating];
}

- (void)updateState
{
  if ([[self operationQueue] operationCount] > 0) {
    [UIView animateWithDuration:0.3 animations:^
    {
      [[self refreshLabel] setText:[self textLoading]];
      [[self refreshArrow] setHidden:YES];
      [[self refreshSpinner] startAnimating];
    }];
  }
  else {
    if ([self overScrollPercent] >= 1.0) {
      [UIView animateWithDuration:0.25 animations:^
      {
        [[self refreshLabel] setText:[self textRelease]];
        [[[self refreshArrow]
                layer]
                setTransform:CATransform3DMakeRotation((CGFloat)M_PI, 0, 0, 1)];
      }];
    }
    else {
      [[self refreshLabel] setText:[self textPull]];
      [[[self refreshArrow]
              layer]
              setTransform:CATransform3DMakeRotation((CGFloat)(M_PI * 2), 0, 0, 1)];
    }
  }
}

- (void)setupStrings
{
  _textPull = @"Pull down to refresh...";
  _textRelease = @"Release to refresh...";
  _textLoading = @"Loading...";
}
@end
