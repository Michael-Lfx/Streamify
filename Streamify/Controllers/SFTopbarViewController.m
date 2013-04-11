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

@property (nonatomic, weak) id<SFTopbarViewControllerProtocol> delegate;

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

- (id)initTopbarWithDelegate:(id)delegate channelState:(SFChannelState)channelState
{
    self = [self initWithNib];
    if (self) {
        self.delegate = delegate;
        self.channelState = channelState;
    }
    return self;
}

- (IBAction)volumeSliderChanged:(id)sender {
    [self.delegate volumeSliderChanged:sender];
}

- (IBAction)controlButtonPressed:(id)sender {
    [self.delegate controlButtonPressed:sender];
}

- (void)setChannelState:(SFChannelState)channelState {
    _channelState = channelState;
    [self.controlButton setImage:[self buttonIconForCurrentState] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SFUIDefaultTheme themeSlider:self.volumeSlider];
    [self.controlButton setImage:[self buttonIconForCurrentState] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setControlButton:nil];
    [self setInfoLabel:nil];
    [self setVolumeSlider:nil];
    [super viewDidUnload];
}

- (UIImage*)buttonIconForCurrentState {
    if (self.channelState == kSFPlayingOrRecordingState) {
        return [UIImage imageNamed:@"topbar-icon-pause.png"];
    } else if (self.channelState == kSFStoppedOrPausedState) {
        return [UIImage imageNamed:@"topbar-icon-play.png"];
    }
}

@end
