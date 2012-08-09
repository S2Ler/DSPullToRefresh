//
//  DSViewController.m
//  DSPullToRefresh
//
//  Created by Alexander Belyavskiy on 8/5/12.
//  Copyright (c) 2012 Diejmon. All rights reserved.
//

#import "DSViewController.h"
#import "DSPullToRefreshViewSimple.h"

@interface DSViewController ()
@end

@implementation DSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {


  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [[self pullToRefreshController] setDelegate:self];
  [[self pullToRefreshController]
    setViewsPositions:DSPullToRefreshViewPositionBottom | DSPullToRefreshViewPositionTop];
  [[self pullToRefreshController]
         setPullToRefreshViewClassHorizontal:[DSPullToRefreshViewSimple class]];
  [[self pullToRefreshController] createViewHierarchy];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  }
  else {
    return YES;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [[UITableViewCell alloc]
                           initWithStyle:UITableViewCellStyleDefault
                         reuseIdentifier:@"REUSE"];
}

- (NSOperation *)pullToRefreshControllerDidRequestedWorkOperation:(DSPullToRefreshController *)theController
                                                  forViewPosition:(DSPullToRefreshViewPosition)thePosition
{
  return [NSBlockOperation blockOperationWithBlock:^
  {
    double x = 1;
    for (long long i = 0; i < 100000000; i++) {
      x = x + sqrt((double)i);
    }
  }];
}

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


@end
