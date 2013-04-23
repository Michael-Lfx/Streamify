//
//  SFSettingsEffectsViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 4/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFSettingsEffectsViewController.h"
#import "SFSettingsAddEffectViewController.h"
#import "SFSettingsManageEffectsViewController.h"

@interface SFSettingsEffectsViewController ()

@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) SFSettingsAddEffectViewController *addEffectViewController;
@property (nonatomic, strong) SFSettingsManageEffectsViewController *manageEffectsViewController;

@end


@implementation SFSettingsEffectsViewController

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
    self.tabBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Effects Library";
    self.contentSizeForViewInPopover =  CGSizeMake(480, 380);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"fuck %@", item);
    switch (item.tag) {
        case 0:
            if (self.addEffectViewController == nil) {
                self.addEffectViewController =[[SFSettingsAddEffectViewController alloc] initWithNib];
            }
            [self.view insertSubview:self.addEffectViewController.view belowSubview:self.tabBar];
            break;
        case 1:
            if (self.manageEffectsViewController == nil) {
                self.manageEffectsViewController =[[SFSettingsManageEffectsViewController alloc] initWithNib];
            }
            [self.view insertSubview:self.manageEffectsViewController.view belowSubview:self.tabBar];
            break;
        default:
            break;
    }
}

- (void)viewDidUnload {
    [self setTabBar:nil];
    [super viewDidUnload];
}
@end
