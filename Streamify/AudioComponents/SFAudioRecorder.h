//
//  SFAudioRecorder.h
//  Streamify
//
//  Created by Le Viet Tien on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFAudioRecorder : NSObject

@property (nonatomic) BOOL isRecording;

@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *sessionToken;
@property (nonatomic) int currentIndex;

+ (SFAudioRecorder *)sharedInstance;
- (void)prepareRecordWithChannel:(NSString *)channel sessionToken:(NSString *)token;
- (void)record;
- (void)stop;

@end
