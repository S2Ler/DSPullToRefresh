//
//  DSPullToRefreshController
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/6/12.

#pragma mark - include
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "DSPullToRefreshController.h"
#import "DSPullToRefreshView.h"
#import "DSPullToRefreshControllerDelegate.h"

#pragma mark - private
#define ANIMATION_DURATION 0.3
#define INSETS_RESET CGFLOAT_MAX

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
  if ([self viewsPositions] & DSPullToRefreshViewPositionTop) {
    [self setRefreshViewTop:[[[self pullToRefreshViewClassHorizontal] alloc] init]];
    CGRect refreshViewFrame = [[self refreshViewTop] frame];
    refreshViewFrame.origin.y = -refreshViewFrame.size.height;
    [[self refreshViewTop] setFrame:refreshViewFrame];
    [[self scrollView] addSubview:[self refreshViewTop]];
  }
  if ([self viewsPositions] & DSPullToRefreshViewPositionBottom) {
    [self setRefreshViewBottom:[[[self pullToRefreshViewClassHorizontal] alloc] init]];
    CGRect refreshViewFrame = [[self refreshViewBottom] frame];
    refreshViewFrame.origin.y = [self contentHeight];

    [[self refreshViewBottom] setFrame:refreshViewFrame];
    [[self scrollView] addSubview:[self refreshViewBottom]];
    [[self scrollView]  addObserver:self
                         forKeyPath:@"contentSize"
                            options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                            context:nil];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == nil) {
    if ([keyPath isEqualToString:@"contentSize"]) {
      [self contentSizeChanged];
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)dealloc
{
  [[self scrollView] removeObserver:self forKeyPath:@"contentSize"];
}


- (void)contentSizeChanged
{
  CGRect refreshViewFrame = [[self refreshViewTop] frame];
  refreshViewFrame.origin.y = [self contentHeight];

  [[self refreshViewBottom] setFrame:refreshViewFrame];
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
    const CGFloat contentHeight = [self contentHeight];
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

- (CGFloat)contentHeight
{
  return MAX([[self scrollView] contentSize].height, [[self scrollView]
                                                            frame].size.height);
}

- (void)applyTransformToScrollViewInsets:(void (^)(UIEdgeInsets *))theTransform
{
  const CGFloat INSETS_NOT_CHANGED = CGFLOAT_MIN;
  UIEdgeInsets deltaInsets = UIEdgeInsetsMake(INSETS_NOT_CHANGED,
                                              INSETS_NOT_CHANGED,
                                              INSETS_NOT_CHANGED,
                                              INSETS_NOT_CHANGED);
  UIEdgeInsets insets = [[self scrollView] contentInset];
  theTransform(&deltaInsets);

  if (deltaInsets.bottom == INSETS_RESET) {
    insets.bottom = 0;
  }
  else if (deltaInsets.bottom != INSETS_NOT_CHANGED) {
    insets.bottom = deltaInsets.bottom;
  }
  if (deltaInsets.top == INSETS_RESET) {
    insets.top = 0;
  }
  else if (deltaInsets.top != INSETS_NOT_CHANGED) {
    insets.top = deltaInsets.top;
  }
  if (deltaInsets.right == INSETS_RESET) {
    insets.right = 0;
  }
  else if (deltaInsets.right != INSETS_NOT_CHANGED) {
    insets.right = deltaInsets.right;
  }
  if (deltaInsets.left == INSETS_RESET) {
    insets.left = 0;
  }
  else if (deltaInsets.left != INSETS_NOT_CHANGED) {
    insets.left = deltaInsets.left;
  }

  [[self scrollView] setContentInset:insets];
}


#pragma mark - UITableViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if ([self viewsPositions] & DSPullToRefreshViewPositionTop) {
    if (![[self refreshViewTop] isLoading]) {
      [[self refreshViewTop] setIsDragging:YES];
    }
  }
  if ([self viewsPositions] & DSPullToRefreshViewPositionBottom) {
    if (![[self refreshViewBottom] isLoading]) {
      [[self refreshViewBottom] setIsDragging:YES];
    }
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if ([self viewsPositions] & DSPullToRefreshViewPositionTop) {
    if ([[self refreshViewTop] isLoading]) {
      // Update the content inset, good for section headers
      if (scrollView.contentOffset.y > 0) {
        [self applyTransformToScrollViewInsets:^(UIEdgeInsets *insets)
        {
          insets->top = INSETS_RESET;
        }];
      }
      else if (scrollView.contentOffset.y >= -[[self refreshViewTop]
                                                     heightForAutoActivation]) {
        [self applyTransformToScrollViewInsets:^(UIEdgeInsets *insets)
        {
          insets->top = -scrollView.contentOffset.y;
        }];
      }
    }
    else if ([[self refreshViewTop] isDragging] && scrollView.contentOffset.y < 0) {
      // Update the arrow direction and label
      [UIView animateWithDuration:0.25 animations:^
      {
        //scrollView.contentOffset.y < -[[self refreshViewTop] heightForAutoActivation]
        if ([[self refreshViewTop] mode] == DSPullToRefreshViewModeAutoActivation) {
          NSAssert(FALSE, @"Not Implemented", nil);
        }
        else if ([[self refreshViewTop] mode] ==
          DSPullToRefreshViewModeReleaseToActivate) {
          [[self refreshViewTop] setOverScrollPercent:
            [self currentActivationProgressForTopView]];
        }
      }];
    }
  }

  if ([self viewsPositions] & DSPullToRefreshViewPositionBottom) {
    const CGFloat offset
      = scrollView.contentOffset.y + scrollView.frame.size.height - [self contentHeight];

    if ([[self refreshViewBottom] isLoading]) {
      // Update the content inset, good for section headers
//      if (offset < 0) {
//
//        [self applyTransformToScrollViewInsets:^(UIEdgeInsets *insets)
//        {
//          insets->bottom = INSETS_RESET;
//        }];
//      }
//      else if (offset >= [[self refreshViewTop] heightForAutoActivation]) {
//
//        [self applyTransformToScrollViewInsets:^(UIEdgeInsets *insets)
//        {
//          insets->bottom = offset;
//        }];
//      }
    }
    else if ([[self refreshViewBottom] isDragging] && offset > 0) {
      // Update the arrow direction and label
      [UIView animateWithDuration:0.25 animations:^
      {
        if ([[self refreshViewBottom] mode] == DSPullToRefreshViewModeAutoActivation) {
          NSAssert(FALSE, @"Not Implemented", nil);
        }
        else if ([[self refreshViewBottom]
                        mode] == DSPullToRefreshViewModeReleaseToActivate) {
          [[self refreshViewBottom] setOverScrollPercent:
            [self currentActivationProgressForBottomView]];
        }
      }];
    }
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
  if ([self viewsPositions] & DSPullToRefreshViewPositionTop) {
    if (![[self refreshViewTop] isLoading]) {
      [[self refreshViewTop] setIsDragging:NO];

      if ([self currentActivationProgressForTopView] >= 1.0) {
        [self startLoadingTopView];
      }
    }
  }

  if ([self viewsPositions] & DSPullToRefreshViewPositionBottom) {
    if (![[self refreshViewBottom] isLoading]) {
      [[self refreshViewBottom] setIsDragging:NO];

      if ([self currentActivationProgressForBottomView] >= 1.0) {
        [self startLoadingBottomView];
      }
    }
  }
}

- (void)startLoadingTopView
{
  [[self refreshViewTop] setIsLoading:YES];

  // Show the header
  [UIView animateWithDuration:ANIMATION_DURATION animations:^
  {

    [self applyTransformToScrollViewInsets:^(UIEdgeInsets *insets)
    {
      insets->top = [[self refreshViewTop] heightForActivation];
    }];
  }];

  NSOperation *workOperation
    = [[self delegate]
             pullToRefreshControllerDidRequestedWorkOperation:self
                                              forViewPosition:DSPullToRefreshViewPositionTop];

  [[self refreshViewTop] activateViewWithWorkOperation:workOperation
                                     completionHandler:^(BOOL success)
                                     {
                                       [[self refreshViewTop] setIsLoading:NO];
                                       [UIView animateWithDuration:ANIMATION_DURATION
                                                        animations:^
                                                        {

                                                          [self applyTransformToScrollViewInsets:^(
                                                            UIEdgeInsets *insets)
                                                          {
                                                            insets->top = INSETS_RESET;
                                                          }];
                                                        }];
                                     }];
}

- (void)startLoadingBottomView
{
  [[self refreshViewBottom] setIsLoading:YES];

  // Show the header
  [UIView animateWithDuration:ANIMATION_DURATION animations:^
  {
    [self applyTransformToScrollViewInsets:^(UIEdgeInsets *insets)
    {
      insets->bottom = MAX([[self scrollView] frame].size.height - [[self scrollView] contentSize].height, 0) + [[self refreshViewBottom] heightForActivation];
    }];
  }];

  NSOperation *workOperation
    = [[self delegate]
             pullToRefreshControllerDidRequestedWorkOperation:self
                                              forViewPosition:DSPullToRefreshViewPositionBottom];

  [[self refreshViewBottom] activateViewWithWorkOperation:workOperation
                                        completionHandler:^(BOOL success)
                                        {
                                          [[self refreshViewBottom] setIsLoading:NO];
                                          [UIView animateWithDuration:ANIMATION_DURATION
                                                           animations:^
                                                           {

                                                             [self applyTransformToScrollViewInsets:^(
                                                               UIEdgeInsets *insets)
                                                             {
                                                               insets->bottom
                                                                 = INSETS_RESET;
                                                             }];
                                                           }];
                                        }];
}

@end
