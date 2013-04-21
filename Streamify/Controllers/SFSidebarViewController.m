//
//  SidebarViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFSidebarViewController.h"
#import "SFSettingsViewController.h"

@interface SFSidebarViewController ()

@property (nonatomic, weak) id<SFSidebarViewControllerProtocol> delegate;
@property (nonatomic) SFSidebarType sidebarType;

@end

@implementation SFSidebarViewController

@synthesize sidebarType = _sidebarType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initSidebarWithOption:(SFSidebarType)sidebarType delegate:(id)delegate
{
    self = [[SFSidebarViewController alloc] initWithNib];
    if (self) {
        self.sidebarType = sidebarType;
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    UIImage *patternImage = [UIImage imageNamed:@"sidebar-background.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(4.0f, 0.0f);
    self.view.layer.shadowOpacity = 0.3f;
    self.view.layer.shadowPath = shadowPath.CGPath;
    
    if (self.sidebarType == kSFSidebarFull) {
        self.backButton.hidden = YES;
    } else {
        self.searchButton.hidden = YES;
        self.trendingButton.hidden = YES;
        self.favouriteButton.hidden = YES;
        self.recentButton.hidden = YES;
        self.broadcastButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setBackButton:nil];
    [self setSearchButton:nil];
    [self setTrendingButton:nil];
    [self setFavouriteButton:nil];
    [self setRecentButton:nil];
    [self setBroadcastButton:nil];
    [self setSettingsButton:nil];
    [super viewDidUnload];
}

- (IBAction)backPressed:(id)sender
{
    [self.delegate backPressed:sender];
}

- (IBAction)searchPressed:(id)sender {
    self.searchButton.selected = YES;
    self.trendingButton.selected = NO;
    self.favouriteButton.selected = NO;
    self.recentButton.selected = NO;
    
    [self.delegate searchPressed:sender];
}

- (IBAction)trendingPressed:(id)sender {
    self.searchButton.selected = NO;
    self.trendingButton.selected = YES;
    self.favouriteButton.selected = NO;
    self.recentButton.selected = NO;
    
    [self.delegate trendingPressed:sender];
}

- (IBAction)favouritePressed:(id)sender {
    self.searchButton.selected = NO;
    self.trendingButton.selected = NO;
    self.favouriteButton.selected = YES;
    self.recentButton.selected = NO;
 
    [self.delegate favouritePressed:sender];
}

- (IBAction)recentPressed:(id)sender {
    self.searchButton.selected = NO;
    self.trendingButton.selected = NO;
    self.favouriteButton.selected = NO;
    self.recentButton.selected = YES;
    
    [self.delegate recentPressed:sender];
}

- (IBAction)broadcastPressed:(id)sender {
    [self.delegate broadcastPressed:sender];
}

- (IBAction)settingsPressed:(id)sender {
    [self.delegate settingsPressed:sender];
}

@end
