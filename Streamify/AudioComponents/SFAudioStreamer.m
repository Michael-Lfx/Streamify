//
//  SFAudioStreamer.m
//  Streamify
//
//  Created by Le Viet Tien on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFAudioStreamer.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SFAudioStreamer()
@property (nonatomic, strong) MPMoviePlayerController *streamPlayer;
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

- (void)preparePlayer {
    self.streamPlayer = [[MPMoviePlayerController alloc] init];
}

- (void)playChannel:(NSString *)channelID {
    [self preparePlayer];
    
    NSString *urlString = [NSString stringWithFormat:@"http://54.251.250.31/%@/a.m3u8", channelID];
    NSLog(@"%@", urlString);
    NSURL *streamURL = [NSURL URLWithString:urlString];
    
    // depending on your implementation your view may not have it's bounds set here
    // in that case consider calling the following 4 msgs later
    self.streamPlayer.movieSourceType = MPMovieSourceTypeStreaming;
    [self.streamPlayer setContentURL:streamURL];
    [self.streamPlayer.view setHidden:YES];
    [self.streamPlayer prepareToPlay];
    [self.streamPlayer play];
}

- (void)stop {
    [self.streamPlayer stop];
}

@end
