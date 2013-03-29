//
//  SidebarViewController.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "BaseViewController.h"

@protocol SFSidebarViewControllerProtocol <NSObject>

- (void)backPressed:(id)sender;

@end

@interface SFSidebarViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *trendingButton;
@property (strong, nonatomic) IBOutlet UIButton *favouriteButton;
@property (strong, nonatomic) IBOutlet UIButton *recentButton;
@property (strong, nonatomic) IBOutlet UIButton *broadcastButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

- (id)initSidebarWithOption:(SFSidebarType)sidebarType delegate:(id)delegate;
- (IBAction)backPressed:(id)sender;

@end
