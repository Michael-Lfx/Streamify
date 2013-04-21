//
//  SFAudioStreamer.h
//  Streamify
//
//  Created by Le Viet Tien on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SFAudioStreamer : MPMoviePlayerController

@property (nonatomic, strong) SFUser *channelPlaying;
@property (nonatomic) float volume;
@property (nonatomic, strong) NSDate *startStreamingTime;

+ (SFAudioStreamer *)sharedInstance;
- (void)playChannel:(SFUser *)channel;

@end
