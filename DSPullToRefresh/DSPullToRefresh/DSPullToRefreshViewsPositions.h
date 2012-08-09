//
//  DSPullToRefreshViewsPositions
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/9/12.

#import <Foundation/Foundation.h>

typedef enum
{
  DSPullToRefreshViewPositionTop = 1,
  DSPullToRefreshViewPositionRight = 1 << 1,
  DSPullToRefreshViewPositionBottom = 1 << 2,
  DSPullToRefreshViewPositionLeft = 1 << 3
} DSPullToRefreshViewPosition;
