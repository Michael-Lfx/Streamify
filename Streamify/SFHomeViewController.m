//
//  MainViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

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
  
    self.canvasViewController = [[SFMetroCanvasViewController alloc] init];
    CGSize canvasSize = self.canvasViewController.view.frame.size;
    self.canvasViewController.view.frame = CGRectMake(130,
                                                 130,
                                                 canvasSize.width,
                                                 canvasSize.height);
    [self.view addSubview:self.canvasViewController.view];
    
    // Testing
    SFSidebarViewController *svc = [[SFSidebarViewController alloc] initWithNib];
    [self.view addSubview:svc.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
