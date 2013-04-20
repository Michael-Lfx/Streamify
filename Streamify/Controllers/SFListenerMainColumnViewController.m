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
@property (nonatomic) NSTimeInterval duration;

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
    self.startListeningTime = [NSDate date];
    self.pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(updateTime)
                                                       userInfo:nil
                                                        repeats:YES];
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
    [[SFAudioStreamer sharedInstance] playChannel:self.user.objectID];
}

- (void)stop {
    [[SFAudioStreamer sharedInstance] stop];
    self.duration = 0;
}

- (IBAction)controlButtonPressed:(id)sender {
    if ([SFAudioStreamer sharedInstance].isPlaying) {
        [self stop];
    } else {
        [self start];
        [self startTimer];
    }
    [self.controlButton setImage:[self controlButtonIconForCurrentChannelState]
                        forState:UIControlStateNormal];
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
        }];
    } else {
        [[SFSocialManager sharedInstance] follows:self.user.objectID withCallback:^(id returnedObject) {
            if ([returnedObject[kOperationResult] isEqualToString:OPERATION_SUCCEEDED]) {
                self.user.followed = YES;
            }
            self.followButton.enabled = YES;
            [self.followButton setImage:[self followButtonIconForCurrentFollowingState]
                               forState:UIControlStateNormal];
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
    
    [SFUIDefaultTheme themeButton:self.followButton];
    [SFUIDefaultTheme themeButton:self.shareButton];
    [SFUIDefaultTheme themeSlider:self.volumeSlider];
    
    
    if ([SFAudioStreamer sharedInstance].isPlaying &&
        ![[SFAudioStreamer sharedInstance].channelPlaying isEqualToString:self.user.objectID]){
        [[SFAudioStreamer sharedInstance] stop];
    }
    
    
    // Buttons
    [self.controlButton setImage:[self controlButtonIconForCurrentChannelState] forState:UIControlStateNormal];
    [self.followButton setImage:[self followButtonIconForCurrentFollowingState] forState:UIControlStateNormal];
    
    if (!self.user.isLive) {
        self.controlButton.enabled = NO;
        self.coverImageView.alpha = 0.3;
    }
    
    // Channel Info
    self.channelInfoLabel.text = [NSString stringWithFormat:@"%@'s Channel", self.user.name];
    
    self.duration = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    if ([SFAudioStreamer sharedInstance].isPlaying) {
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
