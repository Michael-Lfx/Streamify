//
//  SFAudioRecorder.h
//  Streamify
//
//  Created by Le Viet Tien on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SFBroadcastCallback)();

enum {
    SFBroadcastMusicPlaybackStopped = 0,
    SFBroadcastMusicPlaybackPlaying = 1,
    SFBroadcastMusicPlaybackPaused = 2
};
typedef NSUInteger SFBroadcastMusicPlaybackState;

#define SFBroadcastMusicPlaybackStateDidChangeNotification @"SFBroadcastMusicPlaybackStateDidChangeNotification"

@interface SFAudioBroadcaster : NSObject

@property (nonatomic) BOOL isRecording;

@property (nonatomic, strong) NSString *channel;
@property (nonatomic) int currentIndex;
@property (nonatomic) float musicVolume;
@property (nonatomic) SFBroadcastMusicPlaybackState musicPlaybackState;

+ (SFAudioBroadcaster *)sharedInstance;
- (void)prepareRecordWithChannel:(NSString *)channel;
- (void)addMusic:(NSURL *)musicFileURL volume:(float)musicVolume;
- (void)addMusic:(NSURL *)musicFileURL;
- (void)addEffect:(NSURL *)effectFileURL;
- (void)stopMusic;
- (void)record;
- (void)stop;

@end
