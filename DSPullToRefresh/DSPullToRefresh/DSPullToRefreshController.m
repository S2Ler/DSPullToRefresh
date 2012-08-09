//
//  DSPullToRefreshController
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/6/12.

#pragma mark - include
#import "DSPullToRefreshController.h"
#import "DSPullToRefreshView.h"
#import "DSPullToRefreshControllerDelegate.h"

#pragma mark - private
#define ANIMATION_DURATION 0.3

@interface DSPullToRefreshController ()
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isDragging;

@property (nonatomic, strong) UIView<DSPullToRefreshView> *refreshViewTop;
@property (nonatomic, strong) UIView<DSPullToRefreshView> *refreshViewLeft;
@property (nonatomic, strong) UIView<DSPullToRefreshView> *refreshViewRight;
@property (nonatomic, strong) UIView<DSPullToRefreshView> *refreshViewBottom;
@end

@implementation DSPullToRefreshController

- (void)createViewHierarchy
{
  [self setViewsPositions:DSPullToRefreshViewPositionTop | DSPullToRefreshViewPositionBottom];
  if ([self viewsPositions] & DSPullToRefreshViewPositionTop) {
    [self setRefreshViewTop:[[[self pullToRefreshViewClassHorizontal] alloc] init]];
    CGRect refreshViewFrame = [[self refreshViewTop] frame];
    refreshViewFrame.origin.y = -refreshViewFrame.size.height;
    [[self refreshViewTop] setFrame:refreshViewFrame];
    [[self scrollView] addSubview:[self refreshViewTop]];
  }
  if ([self viewsPositions] & DSPullToRefreshViewPositionBottom) {
    [self setRefreshViewBottom:[[[self pullToRefreshViewClassHorizontal] alloc] init]];
    CGRect refreshViewFrame = [[self refreshViewTop] frame];
    refreshViewFrame.origin.y =
      MAX([[self scrollView] contentSize].height, [[self scrollView] frame].size.height);

    [[self refreshViewBottom] setFrame:refreshViewFrame];
    [[self scrollView] addSubview:[self refreshViewBottom]];
  }
}


#pragma mark - Helpers
- (CGFloat)currentActivationProgressForTopView
{
  if ([[self refreshViewTop] mode] == DSPullToRefreshViewModeAutoActivation) {
    NSAssert(FALSE, @"Not implemented", nil);
  }
  else if ([[self refreshViewTop] mode] == DSPullToRefreshViewModeReleaseToActivate) {
    const CGFloat offset = [[self scrollView] contentOffset].y;
    const CGFloat heightForActivation = [[self refreshViewTop] heightForActivation];

    if (offset >= 0) {
      return 0.0;
    }
    else if (offset < -heightForActivation) {
      return 1.0;
    }
    else {
      return offset / heightForActivation;
    }
  }

  NSAssert(FALSE, @"You shouldn't be here", nil);
  return 0.0;
}

- (CGFloat)currentActivationProgressForBottomView
{
  if ([[self refreshViewTop] mode] == DSPullToRefreshViewModeAutoActivation) {
    NSAssert(FALSE, @"Not implemented", nil);
  }
  else if ([[self refreshViewTop] mode] == DSPullToRefreshViewModeReleaseToActivate) {
    const CGFloat offset = [[self scrollView] contentOffset].y;
    const CGFloat contentHeight = [[self scrollView] contentSize].height;
    const CGFloat heightForActivation = [[self refreshViewTop] heightForActivation];
    const CGFloat
      overScroll = contentHeight - (offset + [[self scrollView] frame].size.height);

    if (overScroll >= 0) {
      return 0.0;
    }
    else if (overScroll < -heightForActivation) {
      return 1.0;
    }
    else {
      return overScroll / heightForActivation;
    }
  }

  NSAssert(FALSE, @"You shouldn't be here", nil);
  return 0.0;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if ([self isLoading]) {
    return;
  }
  [self setIsDragging:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if ([self isLoading]) {
    // Update the content inset, good for section headers
    if (scrollView.contentOffset.y > 0) {
      self.scrollView.contentInset = UIEdgeInsetsZero;
    }
    else if (scrollView.contentOffset.y >= -[[self refreshViewTop]
                                                   heightForAutoActivation]) {
      self.scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,
                                                      0,
                                                      0,
                                                      0);
    }
  }
  else if ([self isDragging] && scrollView.contentOffset.y < 0) {
    // Update the arrow direction and label
    [UIView animateWithDuration:0.25 animations:^
    {
      //scrollView.contentOffset.y < -[[self refreshViewTop] heightForAutoActivation]
      if ([[self refreshViewTop] mode] == DSPullToRefreshViewModeAutoActivation) {
        NSAssert(FALSE, @"Not Implemented", nil);
      }
      else if ([[self refreshViewTop] mode] == DSPullToRefreshViewModeReleaseToActivate) {
        [[self refreshViewTop] setOverScrollPercent:
          [self currentActivationProgressForTopView]];
      }
    }];
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
  if ([self isLoading]) {
    return;
  }
  [self setIsDragging:NO];

  if ([self currentActivationProgressForTopView] >= 1.0) {
    [self startLoading];
  }
}

- (void)startLoading
{
  [self setIsLoading:YES];

  // Show the header
  [UIView animateWithDuration:ANIMATION_DURATION animations:^
  {
    self.scrollView.contentInset
      = UIEdgeInsetsMake([[self refreshViewTop] heightForActivation], 0, 0, 0);
  }];

  NSOperation *workOperation
    = [[self delegate] pullToRefreshControllerDidRequestedWorkOperation:self];

  [[self refreshViewTop] activateViewWithWorkOperation:workOperation
                                     completionHandler:^(BOOL success)
                                     {
                                       [self setIsLoading:NO];
                                       [UIView animateWithDuration:ANIMATION_DURATION
                                                        animations:^
                                                        {
                                                          self.scrollView.contentInset
                                                            = UIEdgeInsetsZero;
                                                        }];
                                     }];
}

@end
