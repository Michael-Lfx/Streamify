//
//  SFTopbarViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFTopbarViewController.h"
#import "SFUIDefaultTheme.h"

@interface SFTopbarViewController ()
@property (nonatomic) BOOL stoppedByUser;
@end

@implementation SFTopbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)volumeSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [SFAudioStreamer sharedInstance].volume = slider.value;
}

- (IBAction)controlButtonPressed:(id)sender {
    if ([SFAudioStreamer sharedInstance].playbackState == MPMoviePlaybackStatePlaying) {
        [self stop];
    } else {
        [self start];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updatePlaybackState];
    [self.volumeSlider setValue:[SFAudioStreamer sharedInstance].volume];
}

- (void)updatePlaybackState {
    MPMoviePlaybackState newState = [SFAudioStreamer sharedInstance].playbackState;
    
    if (newState == MPMoviePlaybackStatePlaying) {
        self.infoLabel.text = [NSString stringWithFormat:@"Playing %@'s Channel", [SFAudioStreamer sharedInstance].channelPlaying.name];
    } else {
        self.infoLabel.text = @"No Channel";
    }
    
    NSLog(@"%d", newState);
    [self.controlButton setImage:[self buttonIconForCurrentState] forState:UIControlStateNormal];
}

- (void)start {
//    [[SFAudioStreamer sharedInstance] playChannel:self.user];
}

- (void)stop {
    [[SFAudioStreamer sharedInstance] stop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SFUIDefaultTheme themeSlider:self.volumeSlider];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePlaybackState)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:[SFAudioStreamer sharedInstance]];
    
    [self updatePlaybackState];
//    [self.controlButton setImage:[self buttonIconForCurrentState] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:[SFAudioStreamer sharedInstance]];
}

- (void)viewDidUnload {
    [self setControlButton:nil];
    [self setInfoLabel:nil];
    [self setVolumeSlider:nil];
    [super viewDidUnload];
}

- (UIImage *)buttonIconForCurrentState {
    if ([SFAudioStreamer sharedInstance].playbackState == MPMoviePlaybackStatePlaying) {
        return [UIImage imageNamed:@"topbar-icon-pause.png"];
    } else {
        return [UIImage imageNamed:@"topbar-icon-play.png"];
    }
}

@end
