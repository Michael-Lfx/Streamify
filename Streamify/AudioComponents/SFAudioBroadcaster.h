//
//  SFAudioRecorder.h
//  Streamify
//
//  Created by Le Viet Tien on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SFBroadcastCallback)();

@interface SFAudioBroadcaster : NSObject

@property (nonatomic) BOOL isRecording;

@property (nonatomic, strong) NSString *channel;
@property (nonatomic) int currentIndex;
@property (nonatomic) float musicVolume;

+ (SFAudioBroadcaster *)sharedInstance;
- (void)prepareRecordWithChannel:(NSString *)channel;
- (void)addMusic:(NSURL *)musicFileURL;
- (void)stopMusic;
- (void)record;
- (void)stop;

@end
