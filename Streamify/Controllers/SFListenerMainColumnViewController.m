//
//  SFMainColumnViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFListenerMainColumnViewController.h"
#import "SFUIDefaultTheme.h"

@interface SFListenerMainColumnViewController ()

@property (nonatomic, strong) SFUser *user;
@property (nonatomic, strong) NSDate *startListeningTime;
@property (nonatomic, strong) NSTimer *pollingTimer;
@property (nonatomic, strong) NSTimer *listenerCountTimer;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) BOOL stoppedByUser;

@end

@implementation SFListenerMainColumnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initListenerMainColumnWithUser:(SFUser *)user {
    if (self = [super initWithNib]) {
        self.user = user;
    }
    
    return self;
}

- (void)startTimer {
    self.pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(updateTime)
                                                       userInfo:nil
                                                        repeats:YES];
    [self.pollingTimer fire];
}

- (void)updateTime {
    self.duration = -[self.startListeningTime timeIntervalSinceNow];
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    NSInteger intDuration = duration;
    NSInteger minutes = intDuration / 60;
    NSInteger seconds = intDuration % 60;
    if (seconds >= 10) {
        self.timeLabel.text = [NSString stringWithFormat:@"%d:%d", minutes, seconds];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d", minutes, seconds];
    }
}

- (void)start {
    [[SFAudioStreamer sharedInstance] playChannel:self.user];
}

- (void)stop {
    [[SFAudioStreamer sharedInstance] stop];
}

- (IBAction)controlButtonPressed:(id)sender {
    if ([SFAudioStreamer sharedInstance].playbackState == MPMoviePlaybackStatePlaying) {
        self.stoppedByUser = YES;
        [self stop];
        [self changeServerListenerCount:@"-1"];
    } else {
        [self start];
        [self changeServerListenerCount:@"1"];
        [self publishGraphStory];
    }
}

- (IBAction)volumeSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [SFAudioStreamer sharedInstance].volume = slider.value;
}

- (IBAction)shareButtonPressed:(id)sender {
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
                                            self.shareButton.enabled = YES;
                                        }];
            
            self.shareButton.enabled = NO;
        }];
    }
    
}

- (IBAction)followButtonPressed:(id)sender {
    self.followButton.enabled = NO;
    if (self.user.followed) {
        [[SFSocialManager sharedInstance] unfollows:self.user.objectID withCallback:^(id returnedObject) {
            if ([returnedObject[kOperationResult] isEqualToString:OPERATION_SUCCEEDED]) {
                self.user.followed = NO;
            }
            self.followButton.enabled = YES;
            [self.followButton setImage:[self followButtonIconForCurrentFollowingState]
                               forState:UIControlStateNormal];
            [self.followButton setTitle:[self followButtonTitleForCurrentFollowingState] forState:UIControlStateNormal];
        }];
    } else {
        [[SFSocialManager sharedInstance] follows:self.user.objectID withCallback:^(id returnedObject) {
            if ([returnedObject[kOperationResult] isEqualToString:OPERATION_SUCCEEDED]) {
                self.user.followed = YES;
            }
            self.followButton.enabled = YES;
            [self.followButton setImage:[self followButtonIconForCurrentFollowingState]
                               forState:UIControlStateNormal];
            [self.followButton setTitle:[self followButtonTitleForCurrentFollowingState] forState:UIControlStateNormal];
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(4.0f, 0.0f);
    self.view.layer.shadowOpacity = 0.3f;
    self.view.layer.shadowPath = shadowPath.CGPath;
    
    UIBezierPath *coverShadowPath = [UIBezierPath bezierPathWithRect:self.coverImageView.bounds];
    self.coverImageView.layer.masksToBounds = NO;
    self.coverImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.coverImageView.layer.shadowRadius = 4.0f;
    self.coverImageView.layer.shadowOpacity = 0.5f;
    self.coverImageView.layer.shadowPath = coverShadowPath.CGPath;
    [self.coverImageView setImageWithURL:[NSURL URLWithString:self.user.pictureURL]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    self.coverImageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.4].CGColor;
    self.coverImageView.layer.borderWidth = 1.0;
    
    [SFUIDefaultTheme themeButton:self.followButton];
    [SFUIDefaultTheme themeButton:self.shareButton];
    [SFUIDefaultTheme themeSlider:self.volumeSlider];
    
    if (!self.user.isLive) {
        [self displayOfflineChannel];
    }
    
    // Channel Info
    self.channelInfoLabel.text = [NSString stringWithFormat:@"%@'s Channel", self.user.name];

    self.duration = 0;
    
    if ([SFAudioStreamer sharedInstance].playbackState == MPMoviePlaybackStatePlaying &&
        [[SFAudioStreamer sharedInstance].channelPlaying.objectID isEqualToString:self.user.objectID]){
        self.startListeningTime = [SFAudioStreamer sharedInstance].startStreamingTime;
        [self startTimer];
    } else {
        [self stop];
    }

    self.stoppedByUser = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePlaybackState)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:[SFAudioStreamer sharedInstance]];

    // Buttons
    [self.controlButton setImage:[self controlButtonIconForCurrentChannelState] forState:UIControlStateNormal];
    [self.followButton setImage:[self followButtonIconForCurrentFollowingState] forState:UIControlStateNormal];
    [self.followButton setTitle:[self followButtonTitleForCurrentFollowingState] forState:UIControlStateNormal];
    
    //    [[SFAudioStreamer sharedInstance] addObserver:self
    //                                       forKeyPath:@"playbackState"
    //                                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
    //                                          context:nil];
    
    [self viewWillAppear:YES];
    
    self.personFollowingLabel.hidden = YES;
    [[SFSocialManager sharedInstance] getNumberOfFollwersForUser:self.user.objectID withCallback:^(id returnedObject) {
        if ([returnedObject[kOperationResult] isEqualToString:OPERATION_SUCCEEDED]) {
            int count = [returnedObject[kResultNumberOfFollowers] intValue];
            self.personFollowingLabel.text = [NSString stringWithFormat:@"%d Following", count];
            self.personFollowingLabel.hidden = NO;
        }
    }];
    
    [self updateLocalListenerCount];
    self.listenerCountTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(updateLocalListenerCount)
                                                userInfo:nil
                                                 repeats:YES];
    [self.listenerCountTimer fire];
}

-(void)updateLocalListenerCount{
    [[SFSocialManager sharedInstance] getListenerCount:self.user.objectID withCallback:^(id returnedObject) {
        if ([returnedObject[kOperationResult] isEqualToString:OPERATION_SUCCEEDED]) {
            int count = [returnedObject[kResultNumberofLsiteners] intValue];
            self.personListeningLabel.text = [NSString stringWithFormat:@"%d Listening", count];
        }
    }];
}

-(void)changeServerListenerCount:(NSString *)changeAmount{
    [[SFSocialManager sharedInstance] changeListenerCountInServer:self.user.objectID changeAmount:changeAmount];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"playbackState"]) {
//        MPMoviePlaybackState newState = (MPMoviePlaybackState)[change objectForKey:NSKeyValueChangeNewKey];
//
//        if (newState == MPMoviePlaybackStatePlaying) {
//        } else if (newState == MPMoviePlaybackStateStopped) {
//            if (!self.stoppedByUser) {
//                [self displayOfflineChannel];
//                self.user.isLive = NO;
//            }
//            self.stoppedByUser = NO;
//        } else {
//            NSLog(@"Shit");
//            NSLog(@"%d", newState);
//        }
//
//        [self.controlButton setImage:[self controlButtonIconForCurrentChannelState] forState:UIControlStateNormal];
//    }
//}

- (void)updatePlaybackState {
    MPMoviePlaybackState newState = [SFAudioStreamer sharedInstance].playbackState;
    
    if (newState == MPMoviePlaybackStatePlaying) {
        self.startListeningTime = [SFAudioStreamer sharedInstance].startStreamingTime;
        [self startTimer];
        NSLog(@"Inside Listen Column %@ %d", self, newState);
    } else if (newState == MPMoviePlaybackStatePaused) {
        NSLog(@"Inside Listen Column %@ %d", self, newState);
        [self stop];
    } else if (newState == MPMoviePlaybackStateStopped) {
        NSLog(@"Inside Listen Column %@ %d", self, newState);
        if (!self.stoppedByUser) {
            [self displayOfflineChannel];
            self.user.isLive = NO;
            NSLog(@"Channel offline");
        }
        self.stoppedByUser = NO;
        self.duration = 0;
        [self.pollingTimer invalidate];
     
    }
    
    [self.controlButton setImage:[self controlButtonIconForCurrentChannelState] forState:UIControlStateNormal];
}

- (void)displayOfflineChannel {
    self.controlButton.enabled = NO;
    self.coverImageView.alpha = 0.3;
    [[[UIAlertView alloc] initWithTitle:@"Offline"
                                message:@"This channel is now offline"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCoverImageView:nil];
    [self setTimeLabel:nil];
    [self setControlButton:nil];
    [self setFollowButton:nil];
    [self setShareButton:nil];
    [self setPersonListeningLabel:nil];
    [self setPersonFollowingLabel:nil];
    [self setChannelInfoLabel:nil];
    [self setPersonFollowingLabel:nil];
    [self setVolumeSlider:nil];
    [super viewDidUnload];
}

- (UIImage *)controlButtonIconForCurrentChannelState {
    if ([SFAudioStreamer sharedInstance].playbackState == MPMoviePlaybackStatePlaying) {
        return [UIImage imageNamed:@"maincol-icon-pause.png"];
    } else {
        return [UIImage imageNamed:@"maincol-icon-play.png"];
    }
}


- (UIImage *)followButtonIconForCurrentFollowingState {
    if (self.user.followed) {
        return [UIImage imageNamed:@"maincol-icon-unfollow.png"];
    } else {
        return [UIImage imageNamed:@"maincol-icon-follow.png"];
    }
}

- (NSString *)followButtonTitleForCurrentFollowingState {
    if (self.user.followed) {
        return @"Unfollow this channel";
    } else {
        return @"Follow this channel";
    }
 
}

#pragma mark - FBShare

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.volumeSlider setValue:[SFAudioStreamer sharedInstance].volume];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.listenerCountTimer invalidate];
    [self.pollingTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:[SFAudioStreamer sharedInstance]];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
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

-(void) publishGraphStory{
    [[SFSocialManager sharedInstance] publishGraphStory:self.user.name];
}

@end
