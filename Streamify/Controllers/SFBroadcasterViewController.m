//
//  SFBroadcasterViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 2/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "SFBroadcasterViewController.h"

@interface SFBroadcasterViewController ()

@end

@implementation SFBroadcasterViewController

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

    // Add Chat View
    self.chatViewController = [[SFChatViewController alloc] initChatViewWithDelegate:self];
    self.chatViewController.view.frame = CGRectMake(kSFChatViewFrameX,
                                                    kSFChatViewFrameY,
                                                    kSFChatViewFrameW,
                                                    kSFChatViewFrameH);
    [self.view addSubview:self.chatViewController.view];
    
    // Add Main Column
    self.mainColumnViewController = [[SFMainColumnViewController alloc] initMainColumnWithOption:kSFMainColumnBroadcaster
                                                                                        delegate:self];
    self.mainColumnViewController.view.frame = CGRectMake(kSFMainColumnFrameX,
                                                          kSFMainColumnFrameY,
                                                          kSFMainColumnFrameW,
                                                          kSFMainColumnFrameH);
    [self.view addSubview:self.mainColumnViewController.view];
    
    // Sidebar must be added after main column for shadow
    self.sidebarViewController = [[SFSidebarViewController alloc] initSidebarWithOption:kSFSidebarBackOnly
                                                                               delegate:self];
    [self.view addSubview:self.sidebarViewController.view];
    
    //[self.mainColumnViewController.controlButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchDown];

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
