//
//  BaseTableViewController.h
//  AutoDealer
//
//  Created by Torin on 1/12/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void)deselectAllCellsAnimated:(BOOL)animated;

- (void)fadeInTableView;
- (void)fadeOutTableView;

- (void)refreshTableViewAnimated:(BOOL)animated;

@end
