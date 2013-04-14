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
    
    // Trending canvas
    self.trendingCanvasViewController = [[SFMetroCanvasViewController alloc] initWithTiles:[NSArray array] delegate:self];
    [self positeCanvasViewController:self.trendingCanvasViewController];
    [self.view addSubview:self.trendingCanvasViewController.view];
    [self.trendingCanvasViewController.canvasInitIndicator startAnimating];
    [self canvasDidTriggeredToRefresh];
    [self.view addSubview:self.trendingCanvasViewController.view];
    
    // Favorite canvas
    self.favoriteCanvasViewController = [[SFMetroCanvasViewController alloc] initWithTiles:[NSArray array] delegate:self];
    [self positeCanvasViewController:self.favoriteCanvasViewController];
        
    // Sidebar must be added after main column for shadow
    self.sidebarViewController = [[SFSidebarViewController alloc] initSidebarWithOption:kSFSidebarFull
                                                                               delegate:self];
    [self.view addSubview:self.sidebarViewController.view];
}

- (void)positeCanvasViewController:(SFMetroCanvasViewController *)canvasViewController
{
    CGRect canvasFrame = canvasViewController.view.frame;
    canvasViewController.view.frame = CGRectMake(kSFCanvasFrameXInHomeView,
                                                 kSFCanvasFrameYInHomeView,
                                                 canvasFrame.size.width,
                                                 canvasFrame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [self removeAllCanvases];
    [self.view addSubview:self.trendingCanvasViewController.view];
    [self.trendingCanvasViewController.canvasInitIndicator startAnimating];
    [self canvasDidTriggeredToRefresh];
}

- (void)favouritePressed:(id)sender {
    self.browsingType = kSFFavoriteBrowsing;
    self.canvasTitle.text = @"Favorite";
    [self removeAllCanvases];
    [self.view addSubview:self.favoriteCanvasViewController.view];
    [self.favoriteCanvasViewController.canvasInitIndicator startAnimating];
    [self canvasDidTriggeredToRefresh];
}

- (void)removeAllCanvases
{
    [self.trendingCanvasViewController.view removeFromSuperview];
    [self.trendingCanvasViewController refreshWithTiles:[NSArray array]];
    [self.favoriteCanvasViewController.view removeFromSuperview];
    [self.favoriteCanvasViewController refreshWithTiles:[NSArray array]];
}

- (void)recentPressed:(id)sender {
//    self.browsingType = kSFRecentBrowsing;
//    self.canvasTitle.text = @"Recent";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Supported"
                                                    message:@"Searching coming in the next version !"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)searchPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Supported"
                                                    message:@"History coming in the next version !"
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
    switch (self.browsingType) {
        case kSFTrendingBrowsing:
        {
            [[SFSocialManager sharedInstance] fetchLiveChannelsWithCallback:^(id returnedObject) {
                                                         [self performSelectorInBackground:@selector(refreshTrendingCanvas:)
                                                                                withObject:returnedObject];
                                                     }];
        }
            break;
            
        case kSFFavoriteBrowsing:
        {
            [[SFSocialManager sharedInstance] getFollowingForUser:[SFSocialManager sharedInstance].currentUser.objectID
                                                     withCallback:^(id returnedObject) {
                                                         [self performSelectorInBackground:@selector(refreshFavoriteCanvas:)
                                                                                withObject:returnedObject];
                                                     }];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)refreshTrendingCanvas:(id)returnedObject
{
    NSArray *tiles = [returnedObject objectForKey:kResultLiveChannels];
    [self refreshCanvas:self.trendingCanvasViewController withTiles:tiles];
}

- (void)refreshFavoriteCanvas:(id)returnedObject
{
    NSArray *tiles = [returnedObject objectForKey:kResultFollowing];
    [self refreshCanvas:self.favoriteCanvasViewController withTiles:tiles];
}

- (void)refreshCanvas:(SFMetroCanvasViewController *)canvasViewController
            withTiles:(NSArray *)tiles
{
//    [NSThread sleepForTimeInterval:3];
//    NSMutableArray *temptiles = [NSMutableArray arrayWithArray:tiles];
//    for (int i = 0; i < 7; i++) {
//        [temptiles addObjectsFromArray:tiles];
//    }
    
    if (canvasViewController.canvasInitIndicator.isAnimating) {
        [canvasViewController.canvasInitIndicator stopAnimating];
    }
    
    [canvasViewController canvasScrollViewDataSourceDidFinishedLoading];
    [canvasViewController refreshWithTiles:tiles];
}

@end
