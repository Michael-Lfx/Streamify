//
//  SFAudioStreamer.m
//  Streamify
//
//  Created by Le Viet Tien on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFAudioStreamer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface SFAudioStreamer()
@end

@implementation SFAudioStreamer

+ (SFAudioStreamer *)sharedInstance {
    static SFAudioStreamer *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.channelPlaying = NULL;
        self.startStreamingTime = NULL;
    }
    return self;
}

- (void)playChannel:(NSString *)channelID {
    NSString *urlString = [NSString stringWithFormat:@"http://54.251.250.31/streams/%@/a.m3u8", channelID];
    NSLog(@"%@", urlString);
    NSURL *streamURL = [NSURL URLWithString:urlString];
    
    self.movieSourceType = MPMovieSourceTypeStreaming;
    [self setContentURL:streamURL];
    [self.view setHidden:YES];
    [self prepareToPlay];
    [self play];
    self.startStreamingTime = [NSDate date];
    self.channelPlaying = channelID;
}

- (float)volume {
    return [MPMusicPlayerController applicationMusicPlayer].volume;
}

- (void)setVolume:(float)volume {
    [MPMusicPlayerController applicationMusicPlayer].volume = volume;
}

- (void)stop {
    [super stop];
    self.channelPlaying = NULL;
    self.startStreamingTime = NULL;
}

@end
