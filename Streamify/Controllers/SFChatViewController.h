//
//  SFChatViewController.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 6/4/13.s
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"

@protocol SFChatViewControllerProtocol<NSObject>

@end

@class SFChatTableViewController;

@interface SFChatViewController : BaseViewController

@property (strong, nonatomic) NSMutableArray *messagesData;

@property (strong, nonatomic) SFChatTableViewController *chatTableViewController;
@property (strong, nonatomic) IBOutlet UITextField *chatTextField;

- (IBAction)chatTextEditBeginned:(id)sender;
- (IBAction)chatTextEditEnded:(id)sender;

- (id)initChatViewWithDelegate:(id)delegate;

@end
