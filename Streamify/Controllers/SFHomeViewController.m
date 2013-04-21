//
//  MainViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "SFUIDefaultTheme.h"
#import "SFHomeViewController.h"
#import "SFListenerViewController.h"
#import "SFBroadcasterViewController.h"
#import "SFStorageManager.h"

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

    // Background image
    UIImage *img = [UIImage imageNamed:@"mainbackground.png"];
    self.backgroundImage = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:self.backgroundImage];
    
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
    self.trendingCanvasViewController = [[SFMetroCanvasViewController alloc] initWithTiles:[NSArray array]
                                                                        emptyCanvasMessage:@"There is currently no live channels"
                                                                                  delegate:self];
    [self positeCanvasViewController:self.trendingCanvasViewController];
    [self.view addSubview:self.trendingCanvasViewController.view];
    [self.trendingCanvasViewController.canvasInitIndicator startAnimating];
    [self canvasDidTriggeredToRefresh];
    [self.view addSubview:self.trendingCanvasViewController.view];
    
    // Favorite canvas
    self.favoriteCanvasViewController = [[SFMetroCanvasViewController alloc] initWithTiles:[NSArray array]
                                                                                  emptyCanvasMessage:@"You're not following any channel"
                                                                                  delegate:self];
    [self positeCanvasViewController:self.favoriteCanvasViewController];
    
    // Recents canvas
    self.recentCanvasViewController = [[SFMetroCanvasViewController alloc] initWithTiles:[NSArray array]
                                                                       emptyCanvasMessage:@"There is currently no history"
                                                                                 delegate:self];
    [self positeCanvasViewController:self.recentCanvasViewController];
    
    // Search canvas
    self.searchCanvasViewController = [[SFMetroCanvasViewController alloc] initWithTiles:[NSArray array]
                                                                      emptyCanvasMessage:@"There is currently no result"
                                                                                delegate:self];
    [self positeCanvasViewController:self.searchCanvasViewController];
    
    // Sidebar must be added after main column for shadow
    self.sidebarViewController = [[SFSidebarViewController alloc] initSidebarWithOption:kSFSidebarFull
                                                                               delegate:self];
    [self.view addSubview:self.sidebarViewController.view];
    
    // Search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(kSFSearchBarFrameXHiddenInHomeView, kSFSearchBarFrameYHiddenInHomeView, kSFSearchBarFrameWHiddenInHomeView, kSFSearchBarFrameHHiddenInHomeView)];
    self.searchBar.clipsToBounds = YES;
    [SFUIDefaultTheme themeSearchBar:self.searchBar];
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    
    self.settingsViewController = [[SFSettingsViewController alloc] initWithNib];
    self.settingsViewController.view.frame = CGRectMake(90, 450, 200, 200);
    [self.view addSubview:self.settingsViewController.view];
    self.settingsViewController.view.hidden = YES;
    
//    [[SFSocialManager sharedInstance] searchChannelsForKeyword:@"Zuyet" withCallback:^(id returnedObject) {
//        SFUser *user = [returnedObject[kResultUsers] objectAtIndex:0];
//        DLog(@"%@", user);
//        if (user.followed) {
//            DLog(@"YESSS");
//        }
//    }];
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
    
    [self.topbarViewController setListeningInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [SFAudioStreamer sharedInstance].channelPlaying, @"channelName",
                                                 nil]];
}

#pragma mark - SideBarViewController protocal

- (void)trendingPressed:(id)sender {
    if (self.browsingType == kSFSearchBrowsing) {
        [self hideSearchBar];
    }
    
    self.browsingType = kSFTrendingBrowsing;
    self.canvasTitle.text = @"Trending";
    [self removeAllCanvases];
    [self.view addSubview:self.trendingCanvasViewController.view];
    [self.trendingCanvasViewController.canvasInitIndicator startAnimating];
    [self canvasDidTriggeredToRefresh];
}

- (void)favouritePressed:(id)sender {
    if (self.browsingType == kSFSearchBrowsing) {
        [self hideSearchBar];
    }

    self.browsingType = kSFFavoriteBrowsing;
    self.canvasTitle.text = @"Favorite";
    [self removeAllCanvases];
    [self.view addSubview:self.favoriteCanvasViewController.view];
    [self.favoriteCanvasViewController.canvasInitIndicator startAnimating];
    [self canvasDidTriggeredToRefresh];
}

- (void)recentPressed:(id)sender {
    if (self.browsingType == kSFSearchBrowsing) {
        [self hideSearchBar];
    }

    self.browsingType = kSFRecentBrowsing;
    self.canvasTitle.text = @"Recent";
    [self removeAllCanvases];
    [self.view addSubview:self.recentCanvasViewController.view];
    [self.recentCanvasViewController.canvasInitIndicator startAnimating];
    [self canvasDidTriggeredToRefresh];
}

- (void)searchPressed:(id)sender {
    self.browsingType = kSFSearchBrowsing;

    [self showSearchBar];
    
    self.canvasTitle.text = @"Search";
    [self removeAllCanvases];
    [self.view addSubview:self.searchCanvasViewController.view];
//    [self.searchCanvasViewController.canvasInitIndicator startAnimating];
//    [self canvasDidTriggeredToRefresh];
}

- (void)broadcastPressed:(id)sender {
    SFBroadcasterViewController *broadcasterViewController = [[SFBroadcasterViewController alloc] initWithChannel:[SFSocialManager sharedInstance].currentUser];
    [self.navigationController pushViewController:broadcasterViewController animated:YES];
}

- (void)settingsPressed:(id)sender {
    if(self.settingsViewController.view.hidden == YES)
        self.settingsViewController.view.hidden = NO;
    else
        self.settingsViewController.view.hidden = YES;
}


- (void)removeAllCanvases
{
    [self.trendingCanvasViewController.view removeFromSuperview];
    [self.trendingCanvasViewController refreshWithTiles:[NSArray array]];
    [self.favoriteCanvasViewController.view removeFromSuperview];
    [self.favoriteCanvasViewController refreshWithTiles:[NSArray array]];
    [self.recentCanvasViewController.view removeFromSuperview];
    [self.recentCanvasViewController refreshWithTiles:[NSArray array]];
    [self.searchCanvasViewController.view removeFromSuperview];
    [self.searchCanvasViewController refreshWithTiles:[NSArray array]];
}

- (void)showSearchBar {
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionLayoutSubviews
                     animations:^{self.searchBar.frame = CGRectMake(kSFSearchBarFrameXShownInHomeView, kSFSearchBarFrameYShownInHomeView, kSFSearchBarFrameWShownInHomeView, kSFSearchBarFrameHShownInHomeView);}
                     completion:^(BOOL finished) {
                         [self.searchBar becomeFirstResponder];
                     }];
}

- (void)hideSearchBar {
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionLayoutSubviews
                     animations:^{self.searchBar.frame = CGRectMake(kSFSearchBarFrameXHiddenInHomeView, kSFSearchBarFrameYHiddenInHomeView, kSFSearchBarFrameWHiddenInHomeView, kSFSearchBarFrameHHiddenInHomeView);}
                     completion:^(BOOL finished) {
                         [self.searchBar resignFirstResponder];
                     }];
}

#pragma mark - UISearchBarDelegate protocol 

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keyword = [searchBar.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    if (![keyword isEqualToString:@""]) {
        [[SFSocialManager sharedInstance] searchChannelsForKeyword:keyword withCallback:^(id returnedObject) {
            [self performSelectorInBackground:@selector(refreshSearchCanvas:)
                                   withObject:returnedObject];
            [searchBar resignFirstResponder];
        }];
    }
}

#pragma mark - SFTopBarViewController protocol

- (void)volumeSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [SFAudioStreamer sharedInstance].volume = slider.value;
}

- (void)controlButtonPressed:(id)sender {
    if ([SFAudioStreamer sharedInstance].isPlaying) {
        [[SFAudioStreamer sharedInstance] stop];
        self.topbarViewController.channelState = kSFStoppedOrPausedState;
    }
    
    self.topbarViewController.volume = [SFAudioStreamer sharedInstance].volume;
    
    [self.topbarViewController setListeningInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [SFAudioStreamer sharedInstance].channelPlaying, @"channelName",
                                                 nil]];
}

#pragma mark - SFMetroCanvasViewControlProtocol

- (void)tileDidTapped:(SFUser *)user
{
    SFListenerViewController *listenerViewController = [[SFListenerViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:listenerViewController animated:YES];
    [SFStorageManager saveRecentChannelsUserDefaults:user.objectID];
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
            
        case kSFRecentBrowsing:
        {
            NSArray *objectIDsOfRecentChannels = [SFStorageManager retrieveRecentChannelsUserDefaults];
            [[SFSocialManager sharedInstance] getUsersWithLiveStatusForObjectIDs:objectIDsOfRecentChannels
                                                                    withCallback:^(id returnedObject) {
                                                                        [self performSelectorInBackground:@selector(refreshRecentCanvas:)
                                                                                               withObject:returnedObject];
                                                                    }];
//            [[SFSocialManager sharedInstance] getUsersWithObjectIDs:objectIDsOfRecentChannels
//                                                       withCallback:^(id returnedObject) {
//                                                           [self performSelectorInBackground:@selector(refreshRecentCanvas:)
//                                                                                  withObject:returnedObject];
//                                                       }];
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

- (void)refreshRecentCanvas:(id)returnedObject
{
    NSArray *tiles = [returnedObject objectForKey:kResultUsers];
    [self refreshCanvas:self.recentCanvasViewController withTiles:tiles];
}

- (void)refreshSearchCanvas:(id)returnedObject
{
    NSArray *tiles = [returnedObject objectForKey:kResultUsers];
    [self refreshCanvas:self.searchCanvasViewController withTiles:tiles];
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

- (void)viewDidUnload {
    [super viewDidUnload];
}


@end
