//
//  SFPlaylistControlPanelViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 4/22/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFPlaylistControlPanelViewController.h"

@interface SFPlaylistControlPanelViewController ()

@property (nonatomic, strong) id<SFPlaylistControlPanelDelegate> delegate;

@end


@implementation SFPlaylistControlPanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDelegate:(id)delegate
{
    self = [self initWithNib];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)managePlaylistButtonPressed:(id)sender {
    [self.delegate managePlaylistButtonPressed];
}

- (IBAction)playButtonPressed:(id)sender {
    [self.delegate playButtonPressed];
}

- (IBAction)nextButtonPressed:(id)sender {
    [self.delegate nextButtonPressed];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.delegate backButtonPressed];
}


@end
