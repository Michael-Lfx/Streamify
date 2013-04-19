//
//  SFMusicPickerViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 4/19/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SFMusicPickerViewController.h"
#import "SFSongTableViewCell.h"
#import "SFSong.h"

@interface SFMusicPickerViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *allSongs;

@end

@implementation SFMusicPickerViewController

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    MPMediaQuery *genericQuery = [[MPMediaQuery alloc] init];
    NSArray *itemsFromGenericQuery = [genericQuery items];
    self.allSongs = [NSMutableArray array];
    for (MPMediaItem *songItem in itemsFromGenericQuery) {
        //            NSString *songTitle = [songItem valueForProperty: MPMediaItemPropertyTitle];
        //            NSLog (@"%@", songTitle);
        
        // Get album cover
        MPMediaItemArtwork *artwork = [songItem valueForProperty: MPMediaItemPropertyArtwork];
        UIImage *artworkImage = [artwork imageWithSize: CGSizeMake(70, 70)];
        
        if (!artworkImage) {
            artworkImage = [UIImage imageNamed: @"no_artwork.png"];
        }
        
        SFSong *song = [[SFSong alloc] initWithURL:[songItem valueForProperty:MPMediaItemPropertyAssetURL]
                                             title:[songItem valueForProperty:MPMediaItemPropertyTitle]
                                        artistName:[songItem valueForProperty:MPMediaItemPropertyArtist]
                                        albumTitle:[songItem valueForProperty:MPMediaItemPropertyAlbumTitle]
                                        albumCover:artworkImage];
        [self.allSongs addObject:song];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allSongs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [SFSongTableViewCell cellIdentifier];
    SFSongTableViewCell *cell = (SFSongTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SFSongTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    SFSong *song = [self.allSongs objectAtIndex:indexPath.row];
    
    cell.songTitleLabel.text = song.title;
    cell.artistNameLabel.text = song.artistName;
    cell.albumCoverView.image = song.albumCover;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}



#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"cell is fucking selected");
    SFSong *song = [self.allSongs objectAtIndex:indexPath.row];
    [self mediaItemToData:song.URL];
    
}

-(void)mediaItemToData:(NSURL *)URL
{
    // Implement in your project the media item picker
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:URL options:nil];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset: songAsset
                                                                      presetName: AVAssetExportPresetPassthrough];
    
//    NSLog(@"%@", exporter.supportedFileTypes);
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSArray *directionPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [directionPaths objectAtIndex:0];
    NSString *exportFile = [[NSString alloc] initWithString:[documentsPath stringByAppendingPathComponent:
                            @"exported.caf"]];
    
    NSURL *exportURL = [NSURL fileURLWithPath:exportFile] ;
    exporter.outputURL = exportURL;
    
    // do the export
    // (completion handler block omitted)
    NSLog(@"Start convertion");
    [exporter exportAsynchronouslyWithCompletionHandler:
     ^{
//         NSData *data = [NSData dataWithContentsOfFile:exportFile];
         
         // Do with data something
         NSLog(@"Finished convertion");
         
     }];
}


@end
