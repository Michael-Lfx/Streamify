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
@property (nonatomic, strong) NSTimer *listenerCountTimer;
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

- (IBAction)muteSegmentedControlChanged:(id)sender {
    UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
    NSInteger value = segmentControl.selectedSegmentIndex;
    if (value == 0) {
        [[SFAudioBroadcaster sharedInstance] unmuteRecording];
    } else if (value == 1) {
        [[SFAudioBroadcaster sharedInstance] muteRecording];
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
    self.coverImageView.alpha = 0.3;
    
    self.coverImageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.4].CGColor;
    self.coverImageView.layer.borderWidth = 1.0;
    
    [SFUIDefaultTheme themeButton:self.effect1Button];
    [SFUIDefaultTheme themeButton:self.effect2Button];
    [SFUIDefaultTheme themeButton:self.effect3Button];
    [SFUIDefaultTheme themeButton:self.effect4Button];
    [SFUIDefaultTheme themeSegmentedControl:self.muteSegmentedControl];
    
    // Buttons
    [self.controlButton setImage:[self controlButtonIconForCurrentChannelState] forState:UIControlStateNormal];
    
    // Channel Info
    self.channelInfoLabel.text = [NSString stringWithFormat:@"%@'s Channel", self.user.name];
    
    self.duration = 0;
    
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

- (void)stopRecording {
    [[SFAudioBroadcaster sharedInstance] stop];
    [self.pollingTimer invalidate];
    self.duration = 0;
    self.coverImageView.alpha = 0.3;
    self.muteSegmentedControl.selectedSegmentIndex = 0;
    self.muteSegmentedControl.enabled = NO;
}

- (void)startRecording {
    [[SFAudioBroadcaster sharedInstance] prepareRecordWithChannel:self.user.objectID];
    [[SFAudioBroadcaster sharedInstance] record];
    [self startTimer];
    self.coverImageView.alpha = 1.0;
    self.muteSegmentedControl.enabled = YES;
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

- (void)dealloc {
    [self.pollingTimer invalidate];
    [self.listenerCountTimer invalidate];
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
    [self setMuteSegmentedControl:nil];
    [super viewDidUnload];
}

- (UIImage*)controlButtonIconForCurrentChannelState {
    if ([SFAudioBroadcaster sharedInstance].isRecording) {
        return [UIImage imageNamed:@"maincol-icon-stop.png"];
    } else {
        return [UIImage imageNamed:@"maincol-icon-record.png"];
    }
}
- (IBAction)chipmunkPressed:(id)sender {
    NSString *dir = [[SFStorageManager sharedInstance] directoryForEffectFiles];
    NSURL *URL = [NSURL URLWithString:[dir stringByAppendingString:@"/Chipmunks.caf"]];
    NSLog(@"Effect: %@", URL);
    
    if ([SFAudioBroadcaster sharedInstance].isRecording) {
        [[SFAudioBroadcaster sharedInstance] addEffect:URL];
    }
}
- (IBAction)clappingPressed:(id)sender {
    NSString *dir = [[SFStorageManager sharedInstance] directoryForEffectFiles];
    NSURL *URL = [NSURL URLWithString:[dir stringByAppendingString:@"/Applause.caf"]];
        NSLog(@"Effect: %@", URL);
    
    if ([SFAudioBroadcaster sharedInstance].isRecording) {
        [[SFAudioBroadcaster sharedInstance] addEffect:URL];
    }
}
- (IBAction)bellringPressed:(id)sender {
    NSString *dir = [[SFStorageManager sharedInstance] directoryForEffectFiles];
    NSURL *URL = [NSURL URLWithString:[dir stringByAppendingString:@"/Bell Ringing.caf"]];
        NSLog(@"Effect: %@", URL);
    
    if ([SFAudioBroadcaster sharedInstance].isRecording) {
        [[SFAudioBroadcaster sharedInstance] addEffect:URL];
    }
}
- (IBAction)booingPressed:(id)sender {
    NSString *dir = [[SFStorageManager sharedInstance] directoryForEffectFiles];
    NSURL *URL = [NSURL URLWithString:[dir stringByAppendingString:@"/Booing.caf"]];
        NSLog(@"Effect: %@", URL);
    
    if ([SFAudioBroadcaster sharedInstance].isRecording) {
        [[SFAudioBroadcaster sharedInstance] addEffect:URL];
    }
}

@end
