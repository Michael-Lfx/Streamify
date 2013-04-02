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
  
    self.canvasViewController = [[SFMetroCanvasViewController alloc] initWithDelegate:self];
    CGRect frame = self.canvasViewController.view.frame;
    self.canvasViewController.view.frame = CGRectMake(kSFCanvasFrameXInHomeView,
                                                      kSFCanvasFrameYInHomeView,
                                                      frame.size.width,
                                                      frame.size.height);
                                                      

    [self.view addSubview:self.canvasViewController.view];
    
    // Sidebar must be added after main column for shadow
    self.sidebarViewController = [[SFSidebarViewController alloc] initSidebarWithOption:kSFSidebarFull
                                                                               delegate:self];
    [self.view addSubview:self.sidebarViewController.view];
    
    UIButton *broadcastButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    broadcastButton.frame = CGRectMake(50, 50, 100, 50);
    [broadcastButton setTitle:@"Broadcast" forState:UIControlStateNormal];
    [broadcastButton addTarget:self action:@selector(broadcast) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:broadcastButton];
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
- (IBAction)broadcast {
    RecordViewController *vc = [[RecordViewController alloc] init];
    vc.username = [SFSocialManager sharedInstance].currentUser.objectID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.canvasViewController viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

@end
