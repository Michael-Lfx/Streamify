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

@property (nonatomic, strong) SFUser *channel;
@property (strong, nonatomic) NSMutableArray *messagesData;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) SFChatTableViewController *chatTableViewController;
@property (strong, nonatomic) IBOutlet UITextField *chatTextField;
@property (nonatomic, strong) id<SFChatViewControllerProtocol> delegate;

- (IBAction)chatTextEditBeginned:(id)sender;
- (IBAction)chatTextEditEnded:(id)sender;

//- (id)initChatViewWithDelegate:(id<SFChatViewControllerProtocol>)delegate;
- (id)initWithChannel:(SFUser *)channel;

@end
