//
//  SFPlaylistViewController.m
//  Streamify
//
//  Created by Le Viet Tien on 19/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFPlaylistViewController.h"
#import "SFSongTableViewCell.h"

@interface SFPlaylistViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *playlist;

@end


@implementation SFPlaylistViewController

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
    
    self.topBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self loadPlaylist];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [SFStorageManager savePlaylistUserDefaults:[self getPlaylistURLs]];
    [super viewWillDisappear:animated];
}

- (void)loadPlaylist
{
    NSArray *playlistURLs = [SFStorageManager retrievePlaylist];
    if (!playlistURLs) {
        playlistURLs = [NSArray array];
    }
    
    self.playlist = [NSMutableArray array];
    for (NSString *URL in playlistURLs) {
        SFSong *song = [[SFSong alloc] initWithURL:[NSURL URLWithString:URL]];
        [self.playlist addObject:song];
    }
}
     
- (NSArray *)getPlaylistURLs
{
    NSMutableArray *URLs = [NSMutableArray array];
    for (SFSong *song in self.playlist) {
        [URLs addObject:[song.URL absoluteString]];
    }
    
    return [NSArray arrayWithArray:URLs];
}

- (void)addSong:(SFSong *)song
{
    [self.playlist addObject:song];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [SFSongTableViewCell cellIdentifier];
    SFSongTableViewCell *cell = (SFSongTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kSFSongTableViewCellNibName owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    SFSong *song = [self.playlist objectAtIndex:indexPath.row];
    
    cell.songTitleLabel.text = song.title;
    cell.artistNameLabel.text = song.artistName;
    cell.albumCoverView.image = song.albumCover;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSFSongTableViewCellRowHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.playlist removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark - SFMusicPickerDelegate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setTopBackground:nil];
    [super viewDidUnload];
}
@end
