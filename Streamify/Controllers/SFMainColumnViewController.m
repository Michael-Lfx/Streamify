//
//  SFMainColumnViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFMainColumnViewController.h"
#import "SFUIDefaultTheme.h"

@interface SFMainColumnViewController ()

@property (nonatomic) SFChannelState channelState;
@property (nonatomic) BOOL followingState;
@property (nonatomic, weak) id<SFMainColumnViewControllerProtocol> delegate;
@property (nonatomic) SFMainColumnType mainColumnType;

@end

@implementation SFMainColumnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initMainColumnWithOption:(SFMainColumnType)mainColumnType delegate:(id)delegate channelState:(SFChannelState)channelState followingState:(BOOL)followingState;
{
    self = [self initWithNib];
    self.mainColumnType = mainColumnType;
    self.delegate = delegate;
    self.channelState = channelState;
    self.followingState = followingState;
    return self;
}

- (IBAction)controlButtonPressed:(id)sender {
    [self.delegate controlButtonPressed:sender];
}

- (IBAction)volumeSliderChanged:(id)sender {
    [self.delegate volumeSliderChanged:sender];
}

- (IBAction)shareButtonPressed:(id)sender {
    [self.delegate shareButtonPressed:sender];
}

- (IBAction)followButtonPressed:(id)sender {
    [self.delegate followButtonPressed:sender];
    if (self.followingState == YES) {
        [self setFollowingState:NO];
    } else {
        [self setFollowingState:YES];
    }
}

- (void)setChannelState:(SFChannelState)channelState {
    _channelState = channelState;
    [self.controlButton setImage:[self controlButtonIconForCurrentChannelState] forState:UIControlStateNormal];
}

- (void)setFollowingState:(BOOL)followingState {
    _followingState = followingState;
    [self.followButton setImage:[self followButtonIconForCurrentFollowingState] forState:UIControlStateNormal];
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
    
    [SFUIDefaultTheme themeButton:self.followButton];
    [SFUIDefaultTheme themeButton:self.shareButton];
    [SFUIDefaultTheme themeButton:self.effect1Button];
    [SFUIDefaultTheme themeButton:self.effect2Button];
    [SFUIDefaultTheme themeButton:self.effect3Button];
    [SFUIDefaultTheme themeButton:self.effect4Button];
    
    [SFUIDefaultTheme themeSlider:self.volumeSlider];
    
    if (self.mainColumnType == kSFMainColumnListener) {
        self.broadcasterButtonsView.hidden = YES;
    } else if (self.mainColumnType == kSFMainColumnBroadcaster) {
        self.listenerButtonsView.hidden = YES;
    }
    
    [self.controlButton setImage:[self controlButtonIconForCurrentChannelState] forState:UIControlStateNormal];
    [self.followButton setImage:[self followButtonIconForCurrentFollowingState] forState:UIControlStateNormal];
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
    [self setListenerButtonsView:nil];
    [self setBroadcasterButtonsView:nil];
    [self setEffect1Button:nil];
    [self setEffect2Button:nil];
    [self setEffect3Button:nil];
    [self setEffect4Button:nil];
    [self setVolumeSlider:nil];
    [super viewDidUnload];
}

- (UIImage*)controlButtonIconForCurrentChannelState {
    if (self.mainColumnType == kSFMainColumnBroadcaster) {
        if (self.channelState == kSFPlayingOrRecordingState) {
            return [UIImage imageNamed:@"maincol-icon-stop.png"];
        } else if (self.channelState == kSFStoppedOrPausedState) {
            return [UIImage imageNamed:@"maincol-icon-record.png"];
        }
    } else if (self.mainColumnType == kSFMainColumnListener) {
        if (self.channelState == kSFPlayingOrRecordingState) {
            return [UIImage imageNamed:@"maincol-icon-pause.png"];
        } else if (self.channelState == kSFStoppedOrPausedState) {
            return [UIImage imageNamed:@"maincol-icon-play.png"];
        }
    }
    
    return NULL;
}

- (UIImage*)followButtonIconForCurrentFollowingState {
    if (self.mainColumnType == kSFMainColumnListener) {
        if (self.followingState == NO) {
            return [UIImage imageNamed:@"maincol-icon-follow.png"];
        } else {
            return [UIImage imageNamed:@"maincol-icon-unfollow.png"];
        }
    } else return nil;
}

@end
