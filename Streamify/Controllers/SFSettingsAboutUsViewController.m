//
//  SFSettingsAboutUsViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 4/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFSettingsAboutUsViewController.h"

@interface SFSettingsAboutUsViewController ()

@end

@implementation SFSettingsAboutUsViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"About Us";
    self.contentSizeForViewInPopover =  CGSizeMake(480, 380);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
