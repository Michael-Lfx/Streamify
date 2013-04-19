//
//  SFBroadcasterViewController.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 2/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"
#import "SFSidebarViewController.h"
#import "SFMainColumnViewController.h"
#import "SFChatViewController.h"

@interface SFBroadcasterViewController : BaseViewController <SFSidebarViewControllerProtocol, SFMainColumnViewControllerProtocol>

@property (nonatomic, strong) SFMainColumnViewController *mainColumnViewController;
@property (nonatomic, strong) SFSidebarViewController *sidebarViewController;
@property (nonatomic, strong) SFChatViewController *chatViewController;
@property (nonatomic, strong) SFUser *channel;

- (id)initWithChannel:(SFUser *)channel;

@end
