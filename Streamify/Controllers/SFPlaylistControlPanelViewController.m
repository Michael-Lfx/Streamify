//
//  SFPlaylistControlPanelViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 4/22/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFPlaylistControlPanelViewController.h"
#import "SFUIDefaultTheme.h"
#import "SFPlaylistViewController.h"

@interface SFPlaylistControlPanelViewController ()

@property (nonatomic, strong) id<SFPlaylistControlPanelDelegate> delegate;

@end


@implementation SFPlaylistControlPanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDelegate:(id)delegate
{
    self = [self initWithNib];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self styleSelf];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMusicPlaybackState)
                                                 name:SFBroadcastMusicPlaybackStateDidChangeNotification
                                               object:[SFAudioBroadcaster sharedInstance]];
    
    [self updateButton];
}


- (void)styleSelf {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]];
    self.view.layer.masksToBounds = YES;
    
    [SFUIDefaultTheme themeButton:self.manageButton];
    [SFUIDefaultTheme themeSlider:self.volumeSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)managePlaylistButtonPressed:(id)sender {
    [self.delegate managePlaylistButtonPressed];
}

- (void)updateMusicPlaybackState {
    [self updateButton];
}

- (IBAction)playButtonPressed:(id)sender {
    if ([SFAudioBroadcaster sharedInstance].isRecording == NO) {
        [self showAlert:@"You need to turn on broadcast session before playing music"];
        return;
    }
    if ([SFAudioBroadcaster sharedInstance].musicPlaybackState == SFBroadcastMusicPlaybackPlaying) {
        [[SFAudioBroadcaster sharedInstance] stopMusic];
    } else if ([SFAudioBroadcaster sharedInstance].musicPlaybackState == SFBroadcastMusicPlaybackStopped) {
//        [self.activityIndicator startAnimating];
//        self.controlButton.hidden = YES;
        self.currentSong = self.playlistVC.currentSong;
        self.controlButton.enabled = NO;
        
        __weak SFPlaylistControlPanelViewController *weakSelf = self;
        __weak SFAudioBroadcaster *weakBroadcaster = [SFAudioBroadcaster sharedInstance];
        
        [[SFStorageManager sharedInstance] convertSongAtLibraryURL:self.currentSong.URL withCallback:^(id returnedObject) {
            if ([returnedObject[kOperationResult] isEqualToString:OPERATION_SUCCEEDED]) {
                NSURL *url = returnedObject[@"ResultURL"];
                if (weakBroadcaster.isRecording == YES) {
                    [weakBroadcaster addMusic:url volume:weakSelf.volumeSlider.value];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.controlButton.hidden = NO;
//                [weakSelf.activityIndicator stopAnimating];
                weakSelf.controlButton.enabled = YES;
            });
        }];
    }
}

- (IBAction)volumSliderChanged:(id)sender {
    [[SFAudioBroadcaster sharedInstance] setMusicVolume:self.volumeSlider.value];
}

- (void)showAlert:(NSString *)error {
    [[[UIAlertView alloc] initWithTitle:@"Sorry"
                                message:error
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)updateButton {
    if ([SFAudioBroadcaster sharedInstance].musicPlaybackState == SFBroadcastMusicPlaybackPlaying) {
        [self.controlButton setImage:[UIImage imageNamed:@"playlist-icon-stop.png"] forState:UIControlStateNormal];
    } else if ([SFAudioBroadcaster sharedInstance].musicPlaybackState == SFBroadcastMusicPlaybackStopped) {
        [self.controlButton setImage:[UIImage imageNamed:@"playlist-icon-play.png"] forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SFBroadcastMusicPlaybackStateDidChangeNotification
                                                  object:[SFAudioBroadcaster sharedInstance]];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
}

- (void)viewDidUnload {
    [self setControlButton:nil];
    [self setManageButton:nil];
    [self setVolumeSlider:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}
@end
