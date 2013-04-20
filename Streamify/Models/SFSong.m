//
//  SFPlaylistItem.m
//  Streamify
//
//  Created by Le Viet Tien on 19/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SFSong.h"

@implementation SFSong

- (id)initWithURL:(NSURL *)URL
            title:(NSString *)title
       artistName:(NSString *)artistName
        albumTitle:(NSString *)albumTitle
       albumCover:(UIImage *)albumCover
{
    self = [super init];
    if (self) {
        self.URL = URL;
        self.title = title;
        self.artistName = artistName;
        self.albumTitle = albumTitle;
        self.albumCover = albumCover;
    }
    return self;
}

- (id)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        self.URL = URL;
        
        AVAsset *songAsset = [AVAsset assetWithURL:URL];
        NSArray *metadata = songAsset.commonMetadata;
        
        self.title = [self getNSStringValueForKey:AVMetadataCommonKeyTitle inArray:metadata];
        self.artistName = [self getNSStringValueForKey:AVMetadataCommonKeyArtist inArray:metadata];
        self.albumTitle = [self getNSStringValueForKey:AVMetadataCommonKeyAlbumName inArray:metadata];
        self.albumCover = [self getUIImageValueForKey:AVMetadataCommonKeyArtwork inArray:metadata];
        if (self.albumCover == NULL) {
            self.albumCover = [UIImage imageNamed:kSFSongAlbumCoverImageHolder];
        }
    }
    return self;
}

- (NSString *)getNSStringValueForKey:(NSString *)key inArray:(NSArray *)array
{
    NSArray *result = [AVMetadataItem metadataItemsFromArray:array withKey:key keySpace:AVMetadataKeySpaceCommon];
    if (result.count == 1) {
        AVMetadataItem  *metadataItem = (AVMetadataItem *)[result lastObject];
        return (NSString *)metadataItem.value;
    }
    return NULL;
}

- (UIImage *)getUIImageValueForKey:(NSString *)key inArray:(NSArray *)array
{
    NSArray *result = [AVMetadataItem metadataItemsFromArray:array withKey:key keySpace:AVMetadataKeySpaceCommon];
    if (result.count == 1) {
        AVMetadataItem  *metadataItem = (AVMetadataItem *)[result lastObject];
        NSDictionary *imageDictionary = [metadataItem.value copyWithZone:nil];
        return [UIImage imageWithData:[imageDictionary objectForKey:@"data"]];
    }
    return NULL;
}

@end
