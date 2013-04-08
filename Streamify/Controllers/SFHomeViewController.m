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
#import "SFTileModel.h"
#import "SFBroadcasterViewController.h"

@interface SFHomeViewController ()

@property (nonatomic) SFHomeBrowsingType browsingType;

@end

@implementation SFHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Topbar
    self.topbarViewController = [[SFTopbarViewController alloc] initTopbarWithDelegate:self];
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
    self.canvasViewController = [[SFMetroCanvasViewController alloc] initWithDelegate:self];
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

- (void)tilePressed:(id)sender
{
    SFTileModel *model = (SFTileModel *)sender;
    SFUser *user = model.user;
    SFListenerViewController *listenerViewController = [[SFListenerViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:listenerViewController animated:YES];
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

- (void)broadcastPressed:(id)sender {
//    RecordViewController *vc = [[RecordViewController alloc] init];
//    vc.username = [SFSocialManager sharedInstance].currentUser.objectID;
    SFBroadcasterViewController *vc = [[SFBroadcasterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    // Must change to new SFBroadcasterViewController
}

@end
