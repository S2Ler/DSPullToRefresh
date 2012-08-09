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

@property (nonatomic, strong) UIView<DSPullToRefreshView> *refreshView;
@end

@implementation DSPullToRefreshController

- (void)createViewHierarchy
{
  [self setRefreshView:[[[self pullToRefreshViewClass] alloc] init]];
  CGRect refreshViewFrame = [[self refreshView] frame];
  refreshViewFrame.origin.y = -refreshViewFrame.size.height;
  [[self refreshView] setFrame:refreshViewFrame];
  [[self tableView] addSubview:[self refreshView]];
}


#pragma mark - Helpers
- (CGFloat)currentActivationProgressWithScrollView:(UIScrollView *)theScrollView
{
  if ([[self refreshView] mode] == DSPullToRefreshViewModeAutoActivation) {
    NSAssert(FALSE, @"Not implemented", nil);
  }
  else if ([[self refreshView] mode] == DSPullToRefreshViewModeReleaseToActivate) {
    const CGFloat offset = theScrollView.contentOffset.y;
    const CGFloat heightForActivation = [[self refreshView] heightForActivation];

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
      self.tableView.contentInset = UIEdgeInsetsZero;
    }
    else if (scrollView.contentOffset.y >= -[[self refreshView]
                                                   heightForAutoActivation]) {
      self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,
                                                     0,
                                                     0,
                                                     0);
    }
  }
  else if ([self isDragging] && scrollView.contentOffset.y < 0) {
    // Update the arrow direction and label
    [UIView animateWithDuration:0.25 animations:^
    {
      //scrollView.contentOffset.y < -[[self refreshView] heightForAutoActivation]
      if ([[self refreshView] mode] == DSPullToRefreshViewModeAutoActivation) {
        NSAssert(FALSE, @"Not Implemented", nil);
      }
      else if ([[self refreshView] mode] == DSPullToRefreshViewModeReleaseToActivate) {
        [[self refreshView] setOverScrollPercent:
          [self currentActivationProgressWithScrollView:scrollView]];
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

  if ([self currentActivationProgressWithScrollView:scrollView] >= 1.0) {
    [self startLoading];
  }
}

- (void)startLoading
{
  [self setIsLoading:YES];

  // Show the header
  [UIView animateWithDuration:ANIMATION_DURATION animations:^
  {
    self.tableView.contentInset
      = UIEdgeInsetsMake([[self refreshView] heightForActivation], 0, 0, 0);
  }];

  NSOperation *workOperation
    = [[self delegate] pullToRefreshControllerDidRequestedWorkOperation:self];

  [[self refreshView] activateViewWithWorkOperation:workOperation
                                  completionHandler:^(BOOL success)
                                  {
                                    [self setIsLoading:NO];
                                    [UIView animateWithDuration:ANIMATION_DURATION
                                                     animations:^
                                                     {
                                                       self.tableView.contentInset
                                                         = UIEdgeInsetsZero;
                                                     }];
                                  }];
}

@end
