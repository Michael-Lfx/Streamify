//
//  MainViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//
#import "SFConstants.h"
#import "SFHomeViewController.h"
#import "SFSidebarViewController.h"

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
  
    // Testing
    self.sidebarViewController = [[SFSidebarViewController alloc] initWithNib];;
    [self.view addSubview:self.sidebarViewController.view];
    
  
    self.canvasViewController = [[SFMetroCanvasViewController alloc] init];
    self.canvasViewController.view.frame = CGRectMake(kCanvasFrameXInHomeView,
                                                 kCanvasFrameYInHomeView,
                                                 kCanvasFrameWInHomeView,
                                                 kCanvasFrameHInHomeView);
    [self.view addSubview:self.canvasViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
