//
//  SFStorageManager.h
//  Streamify
//
//  Created by Le Minh Tu on 4/17/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void(^SFStorageCallback)(id returnedObject);

@interface SFStorageManager : NSObject

+ (SFStorageManager *)sharedInstance;
+ (NSArray *)retrieveRecentChannelsUserDefaults;
+ (void)saveRecentChannelsUserDefaults:(NSString *)channelID;
+ (NSArray *)retrievePlaylist;
+ (void)savePlaylistUserDefaults:(NSArray *)playlist;

- (NSString *)directoryForMusicFiles;
- (void)convertSongAtLibraryURL:(NSURL *)URL
                   withCallback:(SFStorageCallback)callback;
- (NSString *)directoryForEffectFiles;
- (NSArray *)getAllEffects;

@end
