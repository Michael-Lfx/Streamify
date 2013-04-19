//
//  SFStorageManager.m
// 
//
//  Created by Le Minh Tu on 4/17/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFStorageManager.h"

#define kSFStorageMaximumNumOfRecentChannels 2
#define kSFStorageRecentChannelsKey @"Recent Channels Key"

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

@end
