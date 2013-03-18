//
//  BaseTableViewController.m
//  AutoDealer
//
//  Created by Torin on 1/12/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self deselectAllCellsAnimated:YES];
}



#pragma mark - Helpers

- (void)deselectAllCellsAnimated:(BOOL)animated
{
  for (UITableViewCell *cell in self.tableView.visibleCells)
  {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
  }
}

- (void)fadeInTableView
{
  [UIView animateWithDuration:0.3 animations:^{
    self.tableView.alpha = 1;
  }];
}

- (void)fadeOutTableView
{
  [UIView animateWithDuration:0.3 animations:^{
    self.tableView.alpha = 0;
  }];
}

- (void)refreshTableViewAnimated:(BOOL)animated
{
  if (animated == NO) {
    [self.tableView reloadData];
    return;
  }
  
  [UIView animateWithDuration:0.3 animations:^{
    self.tableView.alpha = 0;
  } completion:^(BOOL finished) {
    [self.tableView reloadData];
    [self fadeInTableView];
  }];
}

@end
