//
//  SFPlaylistManagerViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 4/19/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFPlaylistManagerViewController.h"
#import "SFSidebarViewController.h"
#import "SFPlaylistViewController.h"


@interface SFPlaylistManagerViewController ()

@property (nonatomic, strong) SFMusicPickerViewController *musicPickerViewController;
@property (nonatomic, strong) SFPlaylistViewController *playlistViewController;
@property (nonatomic, strong) SFSidebarViewController *sidebarViewController;

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
       
    // Streamify Playlist
    self.playlistViewController = [[SFPlaylistViewController alloc] initWithNib];
    [self.playlistViewController.view setFrame:CGRectMake(kSFStreamifyPlaylistViewFrameXInPlaylistManagerView,
                                                          kSFStreamifyPlaylistViewFrameYInPlaylistManagerView,
                                                          self.playlistViewController.view.size.width,
                                                          self.playlistViewController.view.size.height)];
    [self.view addSubview:self.playlistViewController.view];
    
    // Music Library Playlist
    self.musicPickerViewController = [[SFMusicPickerViewController alloc] initWithDelegate:self];
    [self.musicPickerViewController.view setFrame:CGRectMake(kSFLibraryPlaylistViewFrameXInPlaylistManagerView,
                                                             kSFLibraryPlaylistViewFrameYInPlaylistManagerView,
                                                             self.musicPickerViewController.view.size.width,
                                                             self.musicPickerViewController.view.size.height)];
    [self.view addSubview:self.musicPickerViewController.view];
    
    // Side bar
    self.sidebarViewController = [[SFSidebarViewController alloc] initSidebarWithOption:kSFSidebarBackOnly
                                                                               delegate:self];
    [self.view addSubview:self.sidebarViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SFSideBarViewController protocol

- (void)backPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SFMusicPickerViewControllerDelegate

- (void)songSelected:(SFSong *)song
{
    [self.playlistViewController addSong:song];
}

@end
