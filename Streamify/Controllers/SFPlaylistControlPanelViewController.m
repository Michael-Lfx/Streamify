//
//  SFPlaylistControlPanelViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 4/22/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFPlaylistControlPanelViewController.h"

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
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMusicPlaybackState)
                                                 name:SFBroadcastMusicPlaybackStateDidChangeNotification
                                               object:[SFAudioBroadcaster sharedInstance]];
    
    [self updateButton];
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
        self.controlButton.enabled = NO;
        
        __weak SFPlaylistControlPanelViewController *weakSelf = self;
        __weak SFAudioBroadcaster *weakBroadcaster = [SFAudioBroadcaster sharedInstance];
        
        [[SFStorageManager sharedInstance] convertSongAtLibraryURL:self.currentSong.URL withCallback:^(id returnedObject) {
            if ([returnedObject[kOperationResult] isEqualToString:OPERATION_SUCCEEDED]) {
                NSURL *url = returnedObject[@"ResultURL"];
                [weakBroadcaster addMusic:url];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.controlButton.enabled = YES;
            });
        }];
    }
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
        [self.controlButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.controlButton.backgroundColor = [UIColor redColor];
    } else if ([SFAudioBroadcaster sharedInstance].musicPlaybackState == SFBroadcastMusicPlaybackStopped) {
        [self.controlButton setTitle:@"Play" forState:UIControlStateNormal];
        self.controlButton.backgroundColor = [UIColor whiteColor];
    }
}

- (IBAction)nextButtonPressed:(id)sender {
    [self.delegate nextButtonPressed];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.delegate backButtonPressed];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:SFBroadcastMusicPlaybackStateDidChangeNotification
                                               object:[SFAudioBroadcaster sharedInstance]];
    
}

- (void)viewDidUnload {
    [self setControlButton:nil];
    [super viewDidUnload];
}
@end
