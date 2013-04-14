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
    self.chatViewController.channel = self.user.objectID;
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

- (void)shareButtonPressed:(id)sender {
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                    initialText:nil
                                                                          image:nil
                                                                            url:nil
                                                                        handler:nil];
    if (!displayedNativeDialog) {
        
        [self performPublishAction:^{
            // otherwise fall back on a request for permissions and a direct post
            NSString *message = [NSString stringWithFormat:@"I am listening to %@ channel on Streamify!", self.user.name];
            
            [FBRequestConnection startForPostStatusUpdate:message
                                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                            
                                            [self showAlert:message result:result error:error];
                                            self.mainColumnViewController.shareButton.enabled = YES;
                                        }];
            
            self.mainColumnViewController.shareButton.enabled = NO;
        }];
    }
}

- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
    
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 - (void)sendText:(NSString *)text {
 NSString *trimmedString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 NSString *name = [SFSocialManager sharedInstance].currentUser.name;
 NSString *pictureURL = [SFSocialManager sharedInstance].currentUser.pictureURL;
 
 if (trimmedString.length > 0) {
 NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
 self.user.objectID, kMessageChannel,
 name, kMessageName,
 pictureURL, kMessagePictureURL,
 trimmedString, kMessageText,
 nil];
 
 [[SFSocialManager sharedInstance] postMessage:dict withCallback:^(id returnedObject) {
 if ([[returnedObject objectForKey:kOperationResult] isEqual: OPERATION_SUCCEEDED]){
 NSLog(@"Succeeded sending: %@", [returnedObject objectForKey:kResultMessage]);
 }
 }];
 }
 }
 */

- (void)volumeSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [SFAudioStreamer sharedInstance].volume = slider.value;
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        if (error.fberrorShouldNotifyUser ||
            error.fberrorCategory == FBErrorCategoryPermissions ||
            error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
            alertMsg = error.fberrorUserMessage;
        } else {
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.",
                    message];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


@end
