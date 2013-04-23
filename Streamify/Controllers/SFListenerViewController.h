//
//  SFListenerViewController.h
//  Streamify
//
//  Created by Le Minh Tu on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"
#import "SFSidebarViewController.h"
#import "SFChatViewController.h"
#import "SFListenerMainColumnViewController.h"

@interface SFListenerViewController : BaseViewController <SFSidebarViewControllerProtocol>

@property (nonatomic, strong) SFListenerMainColumnViewController *mainColumnViewController;
@property (nonatomic, strong) SFSidebarViewController *sidebarViewController;
@property (nonatomic, strong) SFChatViewController *chatViewController;
@property (nonatomic, strong) SFUser *user;

- (id)initWithUser:(SFUser *)user;

@end
