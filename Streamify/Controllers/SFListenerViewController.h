//
//  SFListenerViewController.h
//  Streamify
//
//  Created by Le Minh Tu on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"
#import "SFSidebarViewController.h"
#import "SFMainColumnViewController.h"

@interface SFListenerViewController : BaseViewController <SFSidebarViewControllerProtocol>

@property (nonatomic, strong) SFMainColumnViewController *mainColumnViewController;
@property (nonatomic, strong) SFSidebarViewController *sidebarViewController;
@property (nonatomic, strong) SFUser *user;
- (id)initWithUser:(SFUser *)user;

@end
