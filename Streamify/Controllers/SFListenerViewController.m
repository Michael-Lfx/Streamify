//
//  SFListenerViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "SFListenerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SFListenerViewController ()
@property (nonatomic) SFChannelState channelState;
@end

@implementation SFListenerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(SFUser *)user {
    if (self = [super init]) {
        self.user = user;
        
        // Default Channel State in controller when started
        self.channelState = kSFStoppedOrPausedState;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Add Chat View
    self.chatViewController = [[SFChatViewController alloc] initChatViewWithDelegate:self];
    self.chatViewController.view.frame = CGRectMake(kSFChatViewFrameX,
                                                          kSFChatViewFrameY,
                                                          kSFChatViewFrameW,
                                                          kSFChatViewFrameH);
    [self.view addSubview:self.chatViewController.view];
    
    
    // Add Main Column
    self.mainColumnViewController = [[SFMainColumnViewController alloc] initMainColumnWithOption:kSFMainColumnListener
                                                                                        delegate:self
                                                                                    channelState:self.channelState];
    self.mainColumnViewController.view.frame = CGRectMake(kSFMainColumnFrameX,
                                                          kSFMainColumnFrameY,
                                                          kSFMainColumnFrameW,
                                                          kSFMainColumnFrameH);
    [self.view addSubview:self.mainColumnViewController.view];
    
    // Sidebar must be added after main column for shadow
    self.sidebarViewController = [[SFSidebarViewController alloc] initSidebarWithOption:kSFSidebarBackOnly
                                                                               delegate:self];
    [self.view addSubview:self.sidebarViewController.view];
    
//    [self.mainColumnViewController.controlButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchDown];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self.user.objectID isEqualToString:[SFAudioStreamer sharedInstance].channelPlaying]) {
        self.channelState = kSFPlayingOrRecordingState;
    } else {
        self.channelState = kSFStoppedOrPausedState;
        [[SFAudioStreamer sharedInstance] stop];
    }
    
    self.mainColumnViewController.volumeSlider.value = [SFAudioStreamer sharedInstance].volume;
    
    [super viewWillAppear:animated];
}

- (void)play {
    [[SFAudioStreamer sharedInstance] playChannel:self.user.objectID];
}

- (void)stop {
    [[SFAudioStreamer sharedInstance] stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controlButtonPressed:(id)sender {
    if (![SFAudioStreamer sharedInstance].isPlaying) {
        [self play];
        
        self.channelState = kSFPlayingOrRecordingState;
    } else if ([SFAudioStreamer sharedInstance].isPlaying) {
        // Pause listening here
        [[SFAudioStreamer sharedInstance] stop];
        
        self.channelState = kSFStoppedOrPausedState;
    }
    [self.mainColumnViewController setChannelState:self.channelState];
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendText:(NSString *)text {
    NSString *trimmedString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *facebookID = [SFSocialManager sharedInstance].currentUser.facebookId;
    if (trimmedString.length > 0) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.user.objectID, kMessageChannel,
                              facebookID, kMessageUser,
                              trimmedString, kMessageText,
                              nil];
        [[SFSocialManager sharedInstance] postMessage:dict withCallback:^(id returnedObject) {
            if ([[returnedObject objectForKey:kOperationResult] isEqual: OPERATION_SUCCEEDED]){
                NSLog(@"Succeeded sending: %@", dict);
            }
        }];
    }
}


- (void)volumeSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [SFAudioStreamer sharedInstance].volume = slider.value;
}

@end
