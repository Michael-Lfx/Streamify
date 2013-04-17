//
//  SFBroadcasterViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 2/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "SFBroadcasterViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Add Chat View
    self.chatViewController = [[SFChatViewController alloc] initChatViewWithDelegate:self];
    self.chatViewController.channel = [SFSocialManager sharedInstance].currentUser.objectID;
    self.chatViewController.view.frame = CGRectMake(kSFChatViewFrameX,
                                                    kSFChatViewFrameY,
                                                    kSFChatViewFrameW,
                                                    kSFChatViewFrameH);
    [self.view addSubview:self.chatViewController.view];
    
    // Add Main Column
    self.mainColumnViewController = [[SFMainColumnViewController alloc] initMainColumnWithOption:kSFMainColumnBroadcaster
                                                                                        delegate:self
                                                                                    channelState:self.channelState
                                                                                  followingState:NO];
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

- (void)viewWillDisappear:(BOOL)animated {
    self.channelState = kSFStoppedOrPausedState;
    [[SFAudioBroadcaster sharedInstance] stop];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SFMainColumnViewController protocol

- (void)controlButtonPressed:(id)sender {
//    if (self.channelState == kSFStoppedOrPausedState) {
    if (![SFAudioBroadcaster sharedInstance].isRecording) {
        [[SFAudioBroadcaster sharedInstance] prepareRecordWithChannel:[PFUser currentUser].objectId];
        [[SFAudioBroadcaster sharedInstance] record];
        
        self.channelState = kSFPlayingOrRecordingState;
//    } else if (self.channelState == kSFPlayingOrRecordingState) {
    } else if ([SFAudioBroadcaster sharedInstance].isRecording) {
        [[SFAudioBroadcaster sharedInstance] stop];
        
        self.channelState = kSFStoppedOrPausedState;
    }
    [self.mainColumnViewController setChannelState:self.channelState];
}

- (void)volumeSliderChanged:(id)sender {
    
}

#pragma mark - SFSideBarViewController protocol

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
