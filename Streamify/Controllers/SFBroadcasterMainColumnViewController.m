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

@property (nonatomic, strong) SFUser *user;
@property (nonatomic, strong) NSDate *startBroadcastingTime;
@property (nonatomic, strong) NSTimer *pollingTimer;
@property (nonatomic) NSTimeInterval duration;

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
    if ([SFAudioBroadcaster sharedInstance].isRecording) {
        [self stopRecording];
        [self.controlButton setImage:[self controlButtonIconForCurrentChannelState] forState:UIControlStateNormal];
    } else {
        [self startRecording];
        [self.controlButton setImage:[self controlButtonIconForCurrentChannelState] forState:UIControlStateNormal];
    }
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
    [self.coverImageView setImageWithURL:[NSURL URLWithString:self.user.pictureURL]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.coverImageView.alpha = 0.3;
    
    [SFUIDefaultTheme themeButton:self.effect1Button];
    [SFUIDefaultTheme themeButton:self.effect2Button];
    [SFUIDefaultTheme themeButton:self.effect3Button];
    [SFUIDefaultTheme themeButton:self.effect4Button];
    [SFUIDefaultTheme themeSlider:self.volumeSlider];
    
    // Buttons
    [self.controlButton setImage:[self controlButtonIconForCurrentChannelState] forState:UIControlStateNormal];
    
    // Channel Info
    self.channelInfoLabel.text = [NSString stringWithFormat:@"%@'s Channel", self.user.name];
    
    self.duration = 0;
}

- (void)stopRecording {
    [[SFAudioBroadcaster sharedInstance] stop];
    [self.pollingTimer invalidate];
    self.duration = 0;
    self.coverImageView.alpha = 0.3;
}

- (void)startRecording {
    [[SFAudioBroadcaster sharedInstance] prepareRecordWithChannel:self.user.objectID];
    [[SFAudioBroadcaster sharedInstance] record];
    [self startTimer];
    self.coverImageView.alpha = 1.0;
}

- (void)startTimer {
    self.startBroadcastingTime = [NSDate date];
    self.pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(updateTime)
                                                       userInfo:nil
                                                        repeats:YES];
}

- (void)updateTime {
    self.duration = -[self.startBroadcastingTime timeIntervalSinceNow];
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
    if ([SFAudioBroadcaster sharedInstance].isRecording) {
        return [UIImage imageNamed:@"maincol-icon-stop.png"];
    } else {
        return [UIImage imageNamed:@"maincol-icon-record.png"];
    }
}

@end
