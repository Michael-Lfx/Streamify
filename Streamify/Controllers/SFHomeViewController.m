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

@interface SFHomeViewController () <UIPopoverControllerDelegate>

@property (nonatomic) SFHomeBrowsingType browsingType;
@property (nonatomic) SFChannelState channelState;
@property (nonatomic, strong) UIPopoverController *popoverVC;

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
    self.topbarViewController = [[SFTopbarViewController alloc] initWithNib];
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
    
    self.settingsMenuViewController = [[SFSettingsMenuViewController alloc] initWithNib];
    self.settingsMenuViewController.view.frame = CGRectMake(90, 450, 500, 300);
    [self.view addSubview:self.settingsMenuViewController.view];
    self.settingsMenuViewController.view.hidden = YES;
    
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
    
    [self.topbarViewController viewWillAppear:YES];
    
    SFMetroCanvasViewController *activeCanvasViewController;
    switch (self.browsingType) {
        case kSFFavoriteBrowsing:
            activeCanvasViewController = self.favoriteCanvasViewController;
            break;
        case kSFTrendingBrowsing:
            activeCanvasViewController = self.trendingCanvasViewController;
            break;
        case kSFRecentBrowsing:
            activeCanvasViewController = self.recentCanvasViewController;
            break;
        case kSFSearchBrowsing:
            activeCanvasViewController = self.searchCanvasViewController;
            break;
    }
    [self activateCanvas:activeCanvasViewController];
    [self positeCanvasViewController:activeCanvasViewController];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - SideBarViewController protocal

- (void)trendingPressed:(id)sender {
    if (self.browsingType == kSFSearchBrowsing) {
        [self hideSearchBar];
    }
    
    self.browsingType = kSFTrendingBrowsing;
    self.canvasTitle.text = @"Trending";
    [self activateCanvas:self.trendingCanvasViewController];
}

- (void)favouritePressed:(id)sender {
    if (self.browsingType == kSFSearchBrowsing) {
        [self hideSearchBar];
    }

    self.browsingType = kSFFavoriteBrowsing;
    self.canvasTitle.text = @"Favorite";
    [self activateCanvas:self.favoriteCanvasViewController];
}

- (void)recentPressed:(id)sender {
    if (self.browsingType == kSFSearchBrowsing) {
        [self hideSearchBar];
    }

    self.browsingType = kSFRecentBrowsing;
    self.canvasTitle.text = @"Recent";
    [self activateCanvas:self.recentCanvasViewController];
}

- (void)activateCanvas:(SFMetroCanvasViewController *)canvasViewController
{
    [self removeAllCanvases];
    [self.view addSubview:canvasViewController.view];
    [canvasViewController.canvasInitIndicator startAnimating];
    canvasViewController.view.userInteractionEnabled = NO;
    [self canvasDidTriggeredToRefresh];
}

- (void)searchPressed:(id)sender {
    self.browsingType = kSFSearchBrowsing;

    [self showSearchBar];
    
    self.canvasTitle.text = @"Search";
    [self removeAllCanvases];
    [self.view addSubview:self.searchCanvasViewController.view];
}

- (void)broadcastPressed:(id)sender {
    [[SFAudioStreamer sharedInstance] stop];
    SFBroadcasterViewController *broadcasterViewController = [[SFBroadcasterViewController alloc] initWithChannel:[SFSocialManager sharedInstance].currentUser];
    [self.navigationController pushViewController:broadcasterViewController animated:YES];
}

- (void)settingsPressed:(id)sender {
    CGRect frame = CGRectMake(self.view.centerX, 170, 0, 0);
    SFSettingsMenuViewController *settingsMenuVC = [[SFSettingsMenuViewController alloc] initWithNib];
    UINavigationController* content = [[UINavigationController alloc] initWithRootViewController:settingsMenuVC];
    self.popoverVC = [[UIPopoverController alloc] initWithContentViewController:content];
    self.popoverVC.delegate = self;
    self.popoverVC.popoverContentSize = CGSizeMake(480, 380);
    [self.popoverVC presentPopoverFromRect:frame
                                    inView:self.view
                  permittedArrowDirections:NO
                                  animated:YES];
    self.view.alpha = 0.5;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.view.alpha = 1.0;
}

- (void)removeAllCanvases
{
    [self.trendingCanvasViewController.view removeFromSuperview];
    [self.trendingCanvasViewController clear];
    [self.favoriteCanvasViewController.view removeFromSuperview];
    [self.favoriteCanvasViewController clear];
    [self.recentCanvasViewController.view removeFromSuperview];
    [self.recentCanvasViewController clear];
    [self.searchCanvasViewController.view removeFromSuperview];
    [self.searchCanvasViewController clear];
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
        }
            break;
        case kSFSearchBrowsing:
        {
            NSString *keyword = [self.searchBar.text stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceCharacterSet]];
            
            if (![keyword isEqualToString:@""]) {
                [[SFSocialManager sharedInstance] searchChannelsForKeyword:keyword
                                                              withCallback:^(id returnedObject) {
                                                                  [self performSelectorInBackground:@selector(refreshSearchCanvas:)
                                                                                         withObject:returnedObject];
                                                              }];
            }
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
        canvasViewController.view.userInteractionEnabled = YES;
    }
    
    [canvasViewController refreshWithTiles:tiles];
}

@end
