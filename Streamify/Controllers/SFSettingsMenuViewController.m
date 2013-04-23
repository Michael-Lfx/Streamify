//
//  SFSettingsMenuViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 4/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFSettingsMenuViewController.h"
#import "SFSettingsAboutUsViewController.h"
#import "SFSettingsEffectsViewController.h"

@interface SFSettingsMenuViewController ()

@end


@implementation SFSettingsMenuViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Settings";
    self.contentSizeForViewInPopover =  CGSizeMake(480, 380);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)effectsLibraryPressed:(id)sender
{
    SFSettingsEffectsViewController *addEffectViewController = [[SFSettingsEffectsViewController alloc] initWithNib];
    [self.navigationController pushViewController:addEffectViewController animated:YES];
}

- (IBAction)aboutUsPressed:(id)sender
{
    SFSettingsAboutUsViewController *settingsAboutUsViewController = [[SFSettingsAboutUsViewController alloc] initWithNib];
    [self.navigationController pushViewController:settingsAboutUsViewController animated:YES];
}

@end
