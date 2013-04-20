//
//  SFBroadcasterViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 2/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "SFBroadcasterViewController.h"
#import "SFPlaylistManagerViewController.h"

@interface SFBroadcasterViewController ()
@property (nonatomic) SFChannelState channelState;
@end

@implementation SFBroadcasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.channelState = kSFStoppedOrPausedState;
    }
    return self;
}

- (id)initWithChannel:(SFUser *)channel {
    if (self = [super init]) {
        self.channel = channel;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Add Chat View
//    self.chatViewController = [[SFChatViewController alloc] initChatViewWithDelegate:self];
//    self.chatViewController = [[SFChatViewController alloc] initWithChannel:self.channel];
//    self.chatViewController.view.frame = CGRectMake(kSFChatViewFrameX,
//                                                    kSFChatViewFrameY,
//                                                    kSFChatViewFrameW,
//                                                    kSFChatViewFrameH);
//    [self.view addSubview:self.chatViewController.view];
    
    // Button to music edit
    UIButton *managePlaylist = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [managePlaylist addTarget:self
                       action:@selector(openManagePlaylist:)
             forControlEvents:UIControlEventTouchDown];
    [managePlaylist setTitle:@"Manage Playlist" forState:UIControlStateNormal];
    managePlaylist.frame = CGRectMake(800.0, 610.0, 160.0, 40.0);
    [self.view addSubview:managePlaylist];
    
    
    // Add Main Column
    self.mainColumnViewController = [[SFBroadcasterMainColumnViewController alloc] initBroadcasterMainColumnWithUser:self.channel];
    
    self.mainColumnViewController.view.frame = CGRectMake(kSFMainColumnFrameX,
                                                          kSFMainColumnFrameY,
                                                          kSFMainColumnFrameW,
                                                          kSFMainColumnFrameH);
    [self.view addSubview:self.mainColumnViewController.view];
    
    // Sidebar must be added after main column for shadow
    self.sidebarViewController = [[SFSidebarViewController alloc] initSidebarWithOption:kSFSidebarBackOnly
                                                                               delegate:self];
    [self.view addSubview:self.sidebarViewController.view];
    
    //[self.mainColumnViewController.controlButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchDown];
}

- (void)openManagePlaylist:(id)sender
{
    SFPlaylistManagerViewController *playlistManagerViewController = [[SFPlaylistManagerViewController alloc] init];
    [self.navigationController pushViewController:playlistManagerViewController animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SFSideBarViewController protocol

- (void)backPressed:(id)sender {
    [self.mainColumnViewController stopRecording];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
