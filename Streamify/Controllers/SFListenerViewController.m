//
//  SFListenerViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "SFListenerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SFListenerViewController ()
@property (nonatomic, strong) MPMoviePlayerController *streamPlayer;
@end

@implementation SFListenerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(SFUser *)user {
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Testing
    self.mainColumnViewController = [[SFMainColumnViewController alloc] init];
    self.mainColumnViewController.view.frame = CGRectMake(kSFMainColumnFrameX,
                                                          kSFMainColumnFrameY,
                                                          kSFMainColumnFrameW,
                                                          kSFMainColumnFrameH);
    [self.view addSubview:self.mainColumnViewController.view];
    
    // Sidebar must be added after main column for shadow
    self.sidebarViewController = [[SFSidebarViewController alloc] initSidebarWithOption:kSFSidebarBackOnly
                                                                               delegate:self];
    [self.view addSubview:self.sidebarViewController.view];
    
    [self.mainColumnViewController.stopButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchDown];
}

- (void)play {
    NSLog(@"HERE");
    NSString *urlString = [NSString stringWithFormat:@"http://54.251.250.31/%@/a.m3u8", self.user.objectID];
    NSLog(@"%@", urlString);
    NSURL *streamURL = [NSURL URLWithString:urlString];
    
    _streamPlayer = [[MPMoviePlayerController alloc] initWithContentURL:streamURL];
    
    // depending on your implementation your view may not have it's bounds set here
    // in that case consider calling the following 4 msgs later
    [self.streamPlayer.view setFrame: self.view.bounds];
    self.streamPlayer.movieSourceType = MPMovieSourceTypeStreaming;
    self.streamPlayer.controlStyle = MPMovieControlModeHidden;
    [self.streamPlayer.view setHidden:YES];
    
    [self.view addSubview: self.streamPlayer.view];
    
    
    [self.streamPlayer play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
