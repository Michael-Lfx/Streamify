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
#import <CoreMedia/CoreMedia.h>

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
    NSString *EXPORT_NAME = @"exported.caf";
    
	AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:URL options:nil];
    
	NSError *assetError = nil;
	AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset
                                                                error:&assetError];
    
	if (assetError) {
		NSLog (@"error: %@", assetError);
		return;
	}
	
	AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
                                               assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                               audioSettings: nil];
                                              
	if (! [assetReader canAddOutput: assetReaderOutput]) {
		NSLog (@"can't add reader output... die!");
		return;
	}
	[assetReader addOutput: assetReaderOutput];
	
	NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
	NSString *exportPath = [documentsDirectoryPath stringByAppendingPathComponent:EXPORT_NAME];
	if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
		[[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
	}
	NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
	AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL
                                                           fileType:AVFileTypeCoreAudioFormat
                                                             error:&assetError];

	if (assetError) {
		NSLog (@"error: %@", assetError);
		return;
	}
	AudioChannelLayout channelLayout;
	memset(&channelLayout, 0, sizeof(AudioChannelLayout));
	channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
	NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
									[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
									[NSNumber numberWithInt:2], AVNumberOfChannelsKey,
									[NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
									[NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
									[NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
									[NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
									[NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
									nil];
	AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                              outputSettings:outputSettings];
    
	if ([assetWriter canAddInput:assetWriterInput]) {
		[assetWriter addInput:assetWriterInput];
	} else {
		NSLog (@"can't add asset writer input... die!");
		return;
	}
	
	assetWriterInput.expectsMediaDataInRealTime = NO;
    
	[assetWriter startWriting];
	[assetReader startReading];
    
	AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
	CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
	[assetWriter startSessionAtSourceTime: startTime];
	
	__block UInt64 convertedByteCount = 0;
	
	dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
	[assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
											usingBlock: ^
	 {
		 // NSLog (@"top of block");
		 while (assetWriterInput.readyForMoreMediaData) {
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
             if (nextBuffer) {
                 // append buffer
                 [assetWriterInput appendSampleBuffer: nextBuffer];
                 //				NSLog (@"appended a buffer (%d bytes)",
                 //					   CMSampleBufferGetTotalSampleSize (nextBuffer));
                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                 // oops, no
                 // sizeLabel.text = [NSString stringWithFormat: @"%ld bytes converted", convertedByteCount];
                 
                 NSNumber *convertedByteCountNumber = [NSNumber numberWithLong:convertedByteCount];
//                 [self performSelectorOnMainThread:@selector(updateSizeLabel:)
//                                        withObject:convertedByteCountNumber
//                                     waitUntilDone:NO];
             } else {
                 // done!
                 [assetWriterInput markAsFinished];
                 [assetWriter finishWriting];
                 [assetReader cancelReading];
                 NSDictionary *outputFileAttributes = [[NSFileManager defaultManager]
                                                       attributesOfItemAtPath:exportPath
                                                       error:nil];
                 NSLog (@"done. file size is %lld",
					    [outputFileAttributes fileSize]);
//                 NSNumber *doneFileSize = [NSNumber numberWithLong:[outputFileAttributes fileSize]];
//                 [self performSelectorOnMainThread:@selector(updateCompletedSizeLabel:)
//                                        withObject:doneFileSize
//                                     waitUntilDone:NO];
                 break;
             }
         }
         
	 }];
	NSLog (@"bottom of convertTapped:");

}


@end
