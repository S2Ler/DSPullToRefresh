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
    [self setPullToRefreshViewClass:[DSPullToRefreshViewSimple class]];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setDelegate:self];
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
  } else {
    return YES;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"REUSE"];
}

- (NSOperation *)pullToRefreshViewControllerDidRequestedWorkOperation:(DSPullToRefreshViewController *)theController
{
  return [NSBlockOperation blockOperationWithBlock:^
  {
     [NSThread sleepForTimeInterval:2];
  }];

}

@end
