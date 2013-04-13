//
//  MainViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//
#import "SFConstants.h"
#import "SFHomeViewController.h"
#import "SFListenerViewController.h"
#import "RecordViewController.h"
#import "SFBroadcasterViewController.h"

@interface SFHomeViewController ()

@property (nonatomic) SFHomeBrowsingType browsingType;
@property (nonatomic) SFChannelState channelState;
@property (nonatomic) BOOL canvasLoading;

@end

@implementation SFHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.channelState = kSFStoppedOrPausedState;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Topbar
    self.topbarViewController = [[SFTopbarViewController alloc] initTopbarWithDelegate:self
                                                                          channelState:self.channelState];
    CGRect topbarFrame = self.topbarViewController.view.frame;
    self.topbarViewController.view.frame = CGRectMake(kSFTopbarFrameXInHomeView,
                                                      kSFTopbarFrameYInHomeView,
                                                      topbarFrame.size.width,
                                                      topbarFrame.size.height);
    [self.view addSubview:self.topbarViewController.view];
    
    // Canvas Title
    self.canvasTitle = [[[NSBundle mainBundle] loadNibNamed:@"SFHomeViewCanvasTitle" owner:self options:nil] lastObject];
    CGRect canvasTitleFrame = self.canvasTitle.frame;
    self.canvasTitle.frame = CGRectMake(kSFCanvasTitleFrameXInHomeView,
                                        kSFCanvasTitleFrameYInHomeView,
                                        canvasTitleFrame.size.width,
                                        canvasTitleFrame.size.height);
    [self.view addSubview:self.canvasTitle];
    
    // Canvas
    self.canvasLoading = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCanvas) name:kUpdateMeSuccessNotification object:nil];
    self.canvasViewController = [[SFMetroCanvasViewController alloc] initWithTiles:[NSArray array] delegate:self];
    CGRect canvasFrame = self.canvasViewController.view.frame;
    self.canvasViewController.view.frame = CGRectMake(kSFCanvasFrameXInHomeView,
                                                      kSFCanvasFrameYInHomeView,
                                                      canvasFrame.size.width,
                                                      canvasFrame.size.height);
    [self.view addSubview:self.canvasViewController.view];
    
    // Sidebar must be added after main column for shadow
    self.sidebarViewController = [[SFSidebarViewController alloc] initSidebarWithOption:kSFSidebarFull
                                                                               delegate:self];
    [self.view addSubview:self.sidebarViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.canvasViewController viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    if ([SFAudioStreamer sharedInstance].isPlaying) {
        self.topbarViewController.channelState = kSFPlayingOrRecordingState;
    } else if (![SFAudioStreamer sharedInstance].isPlaying) {
        self.topbarViewController.channelState = kSFStoppedOrPausedState;
    }
    self.topbarViewController.volume = [SFAudioStreamer sharedInstance].volume;
}

- (void)trendingPressed:(id)sender {
    self.browsingType = kSFTrendingBrowsing;
    self.canvasTitle.text = @"Trending";
}

- (void)favouritePressed:(id)sender {
    self.browsingType = kSFFavoriteBrowsing;
    self.canvasTitle.text = @"Favorite";
}

- (void)recentPressed:(id)sender {
    self.browsingType = kSFRecentBrowsing;
    self.canvasTitle.text = @"Recent";
}

- (void)searchPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Supported"
                                                    message:@"Searching coming in future version !"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)broadcastPressed:(id)sender {
//  RecordViewController *vc = [[RecordViewController alloc] init];
//  vc.username = [SFSocialManager sharedInstance].currentUser.objectID;
    
    SFBroadcasterViewController *broadcasterViewController = [[SFBroadcasterViewController alloc] init];
    [self.navigationController pushViewController:broadcasterViewController animated:YES];
}

- (void)volumeSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [SFAudioStreamer sharedInstance].volume = slider.value;
}

- (void)controlButtonPressed:(id)sender {
    
}

#pragma mark - SFMetroCanvasViewControlProtocol

- (void)tileDidTapped:(SFUser *)user
{
    SFListenerViewController *listenerViewController = [[SFListenerViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:listenerViewController animated:YES];
}

- (void)canvasDidTriggeredToRefresh
{
    self.canvasLoading = YES;
    NSLog(@"fuckkkkk\n");
    [[SFSocialManager sharedInstance] getFollowingForUser:[SFSocialManager sharedInstance].currentUser.objectID
                                             withCallback:^(id returnedObject) {
                                                 self.canvasLoading = NO;
                                                 [self.canvasViewController canvasScrollViewDataSourceDidFinishedLoading];
                                                 NSArray *tiles = [returnedObject objectForKey:kResultFollowing];
                                                 [self.canvasViewController refreshWithTiles:tiles];
                                             }];
//    [self performSelectorInBackground:@selector(requestUpdateTile) withObject:nil];
}

- (BOOL)canvasDataSourceIsLoading
{
    return self.canvasLoading;
}

//- (void)requestUpdateTile
//{
//    NSLog(@"fuk her");
//    [[SFSocialManager sharedInstance] updateMe];
//    [[SFSocialManager sharedInstance] getFollowingForUser:[SFSocialManager sharedInstance].currentUser.objectID
//                                             withCallback:^(id returnedObject) {
//                                                 self.canvasLoading = NO;
//                                                 [self.canvasViewController canvasScrollViewDataSourceDidFinishedLoading];
//                                                 NSArray *tiles = [returnedObject objectForKey:kResultFollowing];
//                                                 [self.canvasViewController refreshWithTiles:tiles];
//                                             }];
//}

- (void)refreshCanvas
{
    self.canvasLoading = NO;
    [self.canvasViewController canvasScrollViewDataSourceDidFinishedLoading];
    NSArray *tiles = [SFSocialManager sharedInstance].currentUser.followings;
    NSLog(@"tiles %@\n", tiles);
    [self.canvasViewController refreshWithTiles:tiles];
    
}

@end
