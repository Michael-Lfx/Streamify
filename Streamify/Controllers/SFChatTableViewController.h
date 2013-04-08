//
//  SFChatTableViewController.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFChatTableViewController : UITableViewController

- (id)initWithData:(NSMutableArray *)data;

@property (weak, nonatomic) NSMutableArray *messagesData;

@end
