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
#import "SFPlaylistViewController.h"
#import "SFPlaylistControlPanelViewController.h"

@interface SFBroadcasterViewController ()

@property (nonatomic, strong) SFPlaylistViewController *playlistViewController;
@property (nonatomic, strong) SFPlaylistControlPanelViewController *playlistControlPanelViewController;
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
    
    
    // Playlist View
    self.playlistViewController = [[SFPlaylistViewController alloc] initWithSelectable:YES editable:NO];
    self.playlistViewController.view.frame = CGRectMake(kSFChatViewFrameX + 1,
                                                        kSFChatViewFrameY,
                                                        kSFChatViewFrameW,
                                                        648);
    [self.view addSubview:self.playlistViewController.view];
     
    // Playlist Control Panel View
    self.playlistControlPanelViewController = [[SFPlaylistControlPanelViewController alloc] initWithDelegate:self];
    self.playlistControlPanelViewController.view.frame = CGRectMake(kSFChatViewFrameX + 1,
                                                                    648,
                                                                    self.playlistControlPanelViewController.view.size.width,
                                                                    self.playlistControlPanelViewController.view.size.height);
    [self.view addSubview:self.playlistControlPanelViewController.view];
    
    self.playlistControlPanelViewController.datasource = self.playlistViewController;
    
    // Add Chat View
    self.chatViewController = [[SFChatViewController alloc] initWithChannel:self.channel];
    [self.chatViewController addFooterWithDisplayed:YES];
    self.chatViewController.view.frame = CGRectMake(kSFChatViewFrameX,
                                                    kSFChatViewFrameY,
                                                    kSFChatViewFrameW,
                                                    kSFChatViewFrameH);
    [self.view addSubview:self.chatViewController.view];
    [self.chatViewController showPlaylist];
    
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.playlistViewController selectRow:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.playlistViewController viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SFSideBarViewController protocol

- (void)backPressed:(id)sender
{
    [self.mainColumnViewController stopRecording];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SFPlaylistControlPanelDelegate

- (void)managePlaylistButtonPressed
{
    SFPlaylistManagerViewController *playlistManagerViewController = [[SFPlaylistManagerViewController alloc] init];
    [self.navigationController pushViewController:playlistManagerViewController animated:YES];
}

- (void)playButtonPressed
{
    
}

- (void)nextButtonPressed
{
    [self.playlistViewController selectNextRow];
}

- (void)backButtonPressed
{
    
    [self.playlistViewController selectPreviousRow];
}

@end
