//
//  SFAudioRecorder.h
//  Streamify
//
//  Created by Le Viet Tien on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFAudioBroadcaster : NSObject

@property (nonatomic) BOOL isRecording;

@property (nonatomic, strong) NSString *channel;
@property (nonatomic) int currentIndex;
@property (nonatomic) float recordVolume;

+ (SFAudioBroadcaster *)sharedInstance;
- (void)prepareRecordWithChannel:(NSString *)channel;
- (void)record;
- (void)stop;

@end
