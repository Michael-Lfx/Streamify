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
    self = [self initWithNib];
    self.user = user;
    return self;
}

- (IBAction)controlButtonPressed:(id)sender {
    
}

- (IBAction)volumeSliderChanged:(id)sender {
}

- (IBAction)shareButtonPressed:(id)sender {
}

- (IBAction)followButtonPressed:(id)sender {
    
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
    [SFUIDefaultTheme themeSlider:self.volumeSlider];
    
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
    [self setVolumeSlider:nil];
    [super viewDidUnload];
}

- (UIImage*)controlButtonIconForCurrentChannelState {
    /*
    if (self.user.) {
        return [UIImage imageNamed:@"maincol-icon-pause.png"];
    } else if (self.channelState == kSFStoppedOrPausedState) {
        return [UIImage imageNamed:@"maincol-icon-play.png"];
    }*/
    return NULL;
}


@end
