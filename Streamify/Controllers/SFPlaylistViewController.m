//
//  SFPlaylistViewController.m
//  Streamify
//
//  Created by Le Viet Tien on 19/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFPlaylistViewController.h"
#import "SFPlaylistItemTableViewCell.h"

@interface SFPlaylistViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *itemsList;
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
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)save {
    [SFStorageManager savePlaylistUserDefaults:self.itemsList];
}

- (void)load {
    self.itemsList = [[SFStorageManager retrievePlaylist] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [SFPlaylistItemTableViewCell cellIdentifier];
    SFPlaylistItemTableViewCell *cell = (SFPlaylistItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SFPlaylistItemTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    SFPlaylistItem *item = [self.itemsList objectAtIndex:indexPath.row];
    
    cell.songNameLabel.text = item.songName;
    cell.artistNameLabel.text = item.artistName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.itemsList removeObjectAtIndex:indexPath.row];
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
    [super viewDidUnload];
}
@end
