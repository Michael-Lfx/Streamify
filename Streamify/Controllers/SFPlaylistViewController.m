//
//  SFPlaylistViewController.m
//  Streamify
//
//  Created by Le Viet Tien on 19/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFPlaylistViewController.h"
#import "SFSongTableViewCell.h"
#import "SFPlaylistControlPanelViewController.h"

@interface SFPlaylistViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *topBackground;
@property (nonatomic, strong) NSMutableArray *playlist;
@property (nonatomic) BOOL editable;
@property (nonatomic) BOOL selectable;


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

- (id)initWithSelectable:(BOOL)selectable editable:(BOOL)editable
{
    self = [self initWithNib];
    if (self) {
        self.selectable = selectable;
        self.editable = editable;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subtle_carbon.png"]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.playlist = [NSMutableArray array];
    [self loadPlaylist];
}

- (void)savePlaylist:(NSArray *)playlist
{
    [SFStorageManager savePlaylistUserDefaults:playlist];
}

- (void)loadPlaylist
{
    NSArray *playlistURLs = [SFStorageManager retrievePlaylist];
    if (!playlistURLs) {
        playlistURLs = [NSArray array];
    }
        
    for (NSString *URL in playlistURLs) {
        SFSong *song = [[SFSong alloc] initWithURL:[NSURL URLWithString:URL]];
        [self.playlist addObject:song];
    }
    [self.tableView reloadData];
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
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        CGPoint bottomOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height);
        [self.tableView setContentOffset:bottomOffset animated:YES];
    }
    [self savePlaylist:[self getPlaylistURLs]];
}

- (void)selectNextRow
{
    NSInteger nextRow = [self.tableView indexPathForSelectedRow].row + 1;
    if (nextRow >= self.playlist.count) {
        nextRow = self.playlist.count - 1;
    }
    [self selectRow:nextRow];
}

- (void)selectPreviousRow
{
    NSInteger previousRow = [self.tableView indexPathForSelectedRow].row - 1;
    if (previousRow < 0) {
        previousRow = 0;
    }
    [self selectRow:previousRow];
}

- (void)selectRow:(NSInteger)row
{
    if (row < 0 || row >= self.playlist.count) {
        return;
    }
    
    self.currentSong = [self.playlist objectAtIndex:row];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)setCurrentSong:(SFSong *)song
{
    _currentSong = song;
//    self.playlistPanelVC.currentSong = song;
}

#pragma mark - SFPlayListDataSourceProtocol

- (SFSong *)currentSelectedSong {
    return self.currentSong;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.playlist removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [self savePlaylist:[self getPlaylistURLs]];
    }
}


#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editable)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSong = [self.playlist objectAtIndex:indexPath.row];
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
