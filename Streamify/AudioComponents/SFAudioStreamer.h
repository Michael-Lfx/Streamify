//
//  SFAudioStreamer.h
//  Streamify
//
//  Created by Le Viet Tien on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFAudioStreamer : NSObject
@property (nonatomic) BOOL isPlaying;
@property (nonatomic, strong) NSString *channelPlaying;
@property (nonatomic) float volume;

+ (SFAudioStreamer *)sharedInstance;
- (void)preparePlayer;
- (void)playChannel:(NSString *)channelID;
- (void)stop;
@end
