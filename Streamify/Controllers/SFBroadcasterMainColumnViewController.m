//
//  SFMainColumnViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFBroadcasterMainColumnViewController.h"
#import "SFUIDefaultTheme.h"

@interface SFBroadcasterMainColumnViewController ()

@property (nonatomic) SFChannelState channelState;
@property (nonatomic) BOOL followingState;
@property (nonatomic, strong) SFUser *user;

@end

@implementation SFBroadcasterMainColumnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initBroadcasterMainColumnWithUser:(SFUser *)user
{
    self = [self initWithNib];
    self.user = user;
    return self;
}

- (IBAction)controlButtonPressed:(id)sender {
    
}

- (IBAction)volumeSliderChanged:(id)sender {
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
    
    [SFUIDefaultTheme themeButton:self.effect1Button];
    [SFUIDefaultTheme themeButton:self.effect2Button];
    [SFUIDefaultTheme themeButton:self.effect3Button];
    [SFUIDefaultTheme themeButton:self.effect4Button];
    [SFUIDefaultTheme themeSlider:self.volumeSlider];
    
    [self.controlButton setImage:[self controlButtonIconForCurrentChannelState] forState:UIControlStateNormal];
    [self.effect1Button setImage:[self followButtonIconForCurrentFollowingState] forState:UIControlStateNormal];
    [self.effect2Button setImage:[self followButtonIconForCurrentFollowingState] forState:UIControlStateNormal];
    [self.effect3Button setImage:[self followButtonIconForCurrentFollowingState] forState:UIControlStateNormal];
    [self.effect4Button setImage:[self followButtonIconForCurrentFollowingState] forState:UIControlStateNormal];
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
    [self setEffect1Button:nil];
    [self setEffect2Button:nil];
    [self setEffect3Button:nil];
    [self setEffect4Button:nil];
    [self setPersonListeningLabel:nil];
    [self setPersonFollowingLabel:nil];
    [self setChannelInfoLabel:nil];
    [self setPersonFollowingLabel:nil];
    [self setVolumeSlider:nil];
    [super viewDidUnload];
}

- (UIImage*)controlButtonIconForCurrentChannelState {
/*    if (self.user.
        return [UIImage imageNamed:@"maincol-icon-stop.png"];
    } else {
        return [UIImage imageNamed:@"maincol-icon-record.png"];
    }
 */
    return NULL;
}

- (UIImage*)followButtonIconForCurrentFollowingState {
    /*
     if (self.user.followed) {
     return [UIImage imageNamed:@"maincol-icon-follow.png"];
     } else {
     return [UIImage imageNamed:@"maincol-icon-unfollow.png"];
     }*/
    return NULL;
}

@end
