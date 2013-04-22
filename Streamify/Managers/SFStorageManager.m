//
//  SFStorageManager.m
//
//
//  Created by Le Minh Tu on 4/17/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFStorageManager.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+MD5.h"

#define kSFStorageMaximumNumOfRecentChannels 1000 // Unlimited History
#define kSFStorageRecentChannelsKey @"Recent Channels Key"

#define kSFStorageMusicMap @"MusicMap"
#define kSFStorageLimitMusicFiles 5

@interface SFStorageManager()

@property (nonatomic, strong) NSMutableDictionary *musicMap;

@end

@implementation SFStorageManager

+ (SFStorageManager *)sharedInstance
{
    static SFStorageManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        NSDictionary *dict = [self retrieveMusicMap];
        if (dict) dict = [NSDictionary dictionary];
        self.musicMap = [dict mutableCopy];
    }
    
    return self;
}

+ (NSArray *)retrieveRecentChannelsUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *recentChannels = [userDefaults arrayForKey:kSFStorageRecentChannelsKey];
    return recentChannels;
}

+ (void)saveRecentChannelsUserDefaults:(NSString *)channelID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentChannels = [[userDefaults arrayForKey:kSFStorageRecentChannelsKey] mutableCopy];
    if (!recentChannels) {
        recentChannels = [NSMutableArray array];
    }
    
    // Remove the ID is already existed in the history.
    [recentChannels removeObject:channelID];
    
    if (recentChannels.count == kSFStorageMaximumNumOfRecentChannels) {
        [recentChannels removeLastObject];
    }
    
    [recentChannels insertObject:channelID atIndex:0];
    [userDefaults setValue:recentChannels forKey:kSFStorageRecentChannelsKey];
    [userDefaults synchronize];
}

+ (NSArray *)retrievePlaylist {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *playlist = [userDefaults arrayForKey:kSFStoragePlaylist];
    return playlist;
}

+ (void)savePlaylistUserDefaults:(NSArray *)playlist {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:playlist forKey:kSFStoragePlaylist];
    [userDefaults synchronize];
}

- (NSDictionary *)retrieveMusicMap {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kSFStorageMusicMap];
}

- (NSURL *)checkPlayable:(NSURL *)libraryURL {
    NSString *EXPORT_NAME = [self.musicMap objectForKey:[libraryURL absoluteString]];
    if (!EXPORT_NAME) return NULL;
    
    NSString *diskURL = [[self directoryForMusicFiles] stringByAppendingPathComponent:EXPORT_NAME];
    
    BOOL isDir;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:diskURL isDirectory:&isDir];
    
    if (!fileExists || isDir) {
        return NULL;
    }
    
    return [NSURL URLWithString:diskURL];
}

- (void)saveMusicMap {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSDictionary dictionaryWithDictionary:self.musicMap] forKey:kSFStorageMusicMap];
    [userDefaults synchronize];
}

- (void)convertSongAtLibraryURL:(NSURL *)URL
                   withCallback:(SFStorageCallback)callback {
    
    NSLog(@"BEGIN");
    
    NSURL *diskURL = [self checkPlayable:URL];
    if (diskURL) {
        NSLog(@"END");
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              OPERATION_SUCCEEDED, kOperationResult,
                              diskURL, @"ResultURL",
                              nil];
        callback((id)dict);
    } else {
        NSString *EXPORT_NAME = [NSString stringWithFormat:@"%@.caf", [[URL absoluteString] MD5Hash]];
        AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:URL options:nil];
        
        NSError *assetError = nil;
        AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset error:&assetError];
        
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
        
        NSString *exportPath = [[self directoryForMusicFiles] stringByAppendingPathComponent:EXPORT_NAME];
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
                                        [NSNumber numberWithFloat:44100.0/2], AVSampleRateKey,
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
        __weak SFStorageManager *weakSelf = self;
        dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
        [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
                                                usingBlock: ^
         {
             while (assetWriterInput.readyForMoreMediaData) {
                 CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
                 if (nextBuffer) {
                     [assetWriterInput appendSampleBuffer: nextBuffer];
                     convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                     CFRelease(nextBuffer);
                 } else {
                     [assetWriterInput markAsFinished];
                     [assetWriter finishWriting];
                     [assetReader cancelReading];
                     NSDictionary *outputFileAttributes = [[NSFileManager defaultManager]
                                                           attributesOfItemAtPath:exportPath
                                                           error:nil];
                     NSLog (@"Done exporting. File size is %lld", [outputFileAttributes fileSize]);
                     
                     [weakSelf.musicMap setObject:EXPORT_NAME forKey:[URL absoluteString]];
                     [weakSelf saveMusicMap];
                     
                     NSLog(@"END");
                     
                     NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                           OPERATION_SUCCEEDED, kOperationResult,
                                           exportURL, @"ResultURL",
                                           nil];
                     
                     callback((id)dict);
                     break;
                 }
             }
             
         }];

    }
}

- (NSString *)directoryForMusicFiles {
    NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0];
    NSString *musicFolder = [documentsFolder stringByAppendingPathComponent:@"MusicFiles"];
    BOOL isDir;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:musicFolder isDirectory:&isDir];
    
    if (!fileExists) {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:musicFolder
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error]) {
            DLog(@"%@", error);
        }
    }
    
    return musicFolder;
}

@end
