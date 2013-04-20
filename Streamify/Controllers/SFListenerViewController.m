//
//  SFListenerViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "SFListenerViewController.h"
#import "SFListenerMainColumnViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SFListenerViewController ()
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
    
    // Add Chat View
//    self.chatViewController = [[SFChatViewController alloc] initChatViewWithDelegate:self];
//    self.chatViewController = [[SFChatViewController alloc] initWithChannel:self.user];
//    self.chatViewController.view.frame = CGRectMake(kSFChatViewFrameX,
//                                                    kSFChatViewFrameY,
//                                                    kSFChatViewFrameW,
//                                                    kSFChatViewFrameH);
//    [self.view addSubview:self.chatViewController.view];
    
    
    // Add Main Column
    self.mainColumnViewController = [[SFListenerMainColumnViewController alloc] initListenerMainColumnWithUser:self.user];
    self.mainColumnViewController.view.frame = CGRectMake(kSFMainColumnFrameX,
                                                          kSFMainColumnFrameY,
                                                          kSFMainColumnFrameW,
                                                          kSFMainColumnFrameH);
    [self.view addSubview:self.mainColumnViewController.view];
    
    // Sidebar must be added after main column for shadow
    self.sidebarViewController = [[SFSidebarViewController alloc] initSidebarWithOption:kSFSidebarBackOnly
                                                                               delegate:self];
    [self.view addSubview:self.sidebarViewController.view];
    
    //    [self.mainColumnViewController.controlButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchDown];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SFSidebarProtocol

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
