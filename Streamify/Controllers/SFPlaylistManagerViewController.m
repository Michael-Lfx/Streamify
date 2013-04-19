//
//  SFPlaylistManagerViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 4/19/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFPlaylistManagerViewController.h"
#import "SFPlaylistViewController.h"
#import "SFMusicPickerViewController.h"

@interface SFPlaylistManagerViewController ()

@property (nonatomic, strong) SFMusicPickerViewController *musicPickerViewController;
@property (nonatomic, strong) SFPlaylistViewController *playlistViewController;

@end

@implementation SFPlaylistManagerViewController

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
	// Do any additional setup after loading the view.
    
    self.playlistViewController = [[SFPlaylistViewController alloc] initWithNib];
    self.musicPickerViewController = [[SFMusicPickerViewController alloc] initWithNib];
    [self.musicPickerViewController.view setFrame:CGRectMake(512,
                                                             0,
                                                             self.musicPickerViewController.view.size.width,
                                                             self.musicPickerViewController.view.size.height)];
    [self.view addSubview:self.playlistViewController.view];
    [self.view addSubview:self.musicPickerViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
