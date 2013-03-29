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
    self.sidebarViewController = [[SFSidebarViewController alloc] initSidebarWithOption:kSFSidebarFull];
    [self.view addSubview:self.sidebarViewController.view];
}

- (void)tilePressed:(id)sender {
    SFListenerViewController *listenerViewController = [[SFListenerViewController alloc] init];
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
}

@end
