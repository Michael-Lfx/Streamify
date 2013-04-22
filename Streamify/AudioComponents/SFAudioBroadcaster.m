//
//  SFAudioRecorder.m
//  Streamify
//
//  Created by Le Viet Tien on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFAudioBroadcaster.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "GCDTimer.h"
#import "AEAudioController.h"
#import "AERecorder.h"

@interface SFAudioBroadcaster() <AVAudioRecorderDelegate>
@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AERecorder *audioRecorder;
@property (nonatomic, strong) AEAudioFilePlayer *audioFilePlayer;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *recordFilePath;
@property (nonatomic) NSUInteger lastBytes;
//@property GCDTimer *timer;
@property NSTimer *timer;
@end

@implementation SFAudioBroadcaster

+ (SFAudioBroadcaster *)sharedInstance {
    static SFAudioBroadcaster *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

/*
 - (void)prepareRecord {
 self.userID = [SFSocialManager sharedInstance].currentUser.objectID;
 self.count = -1;
 self.lastBytes = -1;
 self.isRecording = NO;
 }
 */

- (id)init {
    if (self = [super init]) {
        self.isRecording = NO;
        AudioStreamBasicDescription audioFormat = [AEAudioController nonInterleavedFloatStereoAudioDescription];
        self.audioController = [[AEAudioController alloc] initWithAudioDescription:audioFormat
                                                                      inputEnabled:YES];
        NSError *error = NULL;
        BOOL result = [self.audioController start:&error];
        if ( !result ) {
            // Report error
            NSLog(@"%@", error);
        }
        
        self.audioRecorder = [[AERecorder alloc] initWithAudioController:self.audioController];
        NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
                                     objectAtIndex:0];
        self.recordFilePath = [documentsFolder stringByAppendingPathComponent:@"Record.aac"];
    }
    return self;
}

- (void)prepareRecordWithChannel:(NSString *)channel {
    self.channel = channel;
    self.currentIndex = -1;
    self.lastBytes = -1;
    self.isRecording = NO;
}

- (void)record {
    // Start the recording process
    NSError *error = NULL;
    if ( ![_audioRecorder beginRecordingToFileAtPath:self.recordFilePath
                                            fileType:kAudioFileAAC_ADTSType
                                               error:&error] ) {
        // Report error
        DLog(@"Somgthing wrong with recording");
        return;
    }
    // Receive both audio input and audio output. Note that if you're using
    // AEPlaythroughChannel, mentioned above, you may not need to receive the input again.
    [self.audioController addInputReceiver:self.audioRecorder];
    [self.audioController addOutputReceiver:self.audioRecorder];
    
    self.isRecording = YES;
    [self sendCreateRequestToServer];
    [self startTimer];
}

- (void)addMusic:(NSURL *)musicFileURL {
    NSError *error;
    self.audioFilePlayer = [AEAudioFilePlayer audioFilePlayerWithURL:musicFileURL
                                                     audioController:self.audioController
                                                               error:&error];
    
    self.audioFilePlayer.volume = 0.1;
    self.audioFilePlayer.channelIsPlaying = YES;
    self.audioFilePlayer.removeUponFinish = YES;
    
    [self.audioController addChannels:[NSArray arrayWithObjects:_audioFilePlayer, nil]];
}

- (void)stopMusic {
    if (self.audioFilePlayer) {
        [self.audioController removeChannels:[NSArray arrayWithObjects:_audioFilePlayer, nil]];
        self.audioFilePlayer = nil;
    }
}

- (void)pauseMusic {
    if (self.audioFilePlayer) {
        self.audioFilePlayer.channelIsPlaying = NO;
    }
}

- (void)resumeMusic {
    if (self.audioFilePlayer) {
        self.audioFilePlayer.channelIsPlaying = YES;
    }
}

- (void)setMusicVolume:(float)musicVolume {
    _musicVolume = musicVolume;
    if (self.audioFilePlayer) {
        self.audioFilePlayer.volume = musicVolume;
    }
}

//- (void)startTimer {
//    dispatch_queue_t queue = dispatch_queue_create("streamify.cs3217.nus", DISPATCH_QUEUE_CONCURRENT);
//    self.timer = [GCDTimer timerOnQueue:queue withLeeway:TIMER_LEEWAY_NONE name:@"RecorderTimer"];
//    [self.timer scheduleBlock:^{
//        [self send];
//    } afterInterval:10.0 repeat:YES];
//}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0f
                                                  target:self
                                                selector:@selector(send)
                                                userInfo:nil
                                                 repeats:YES];
}

- (BOOL)sendCreateRequestToServer {
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://54.251.250.31"]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.channel, nil]
                                                       forKeys:[NSArray arrayWithObjects:@"username", nil]];
    NSMutableURLRequest *requets = [client requestWithMethod:@"POST" path:@"/create.php" parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requets];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS: CREATE REQUEST");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL: CREATE REQUEST");
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    return YES;
}

- (BOOL)sendStopRequestToServer {
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://54.251.250.31"]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.channel, nil]
                                                       forKeys:[NSArray arrayWithObjects:@"username", nil]];
    NSMutableURLRequest *requets = [client requestWithMethod:@"POST" path:@"/stop.php" parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requets];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS: STOP AUDIO");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL: STOP REQUEST");
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    return YES;
}

- (BOOL)sendAudioToServer:(NSData *)data withCallback:(SFBroadcastCallback)callback{
    NSData *d = [NSData dataWithData:data];
    //now you'll just have to send that NSData to your server
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://54.251.250.31"]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:self.channel forKey:@"username"];
    NSMutableURLRequest *myRequest = [client multipartFormRequestWithMethod:@"POST"
                                                                       path:@"/upload.php"
                                                                 parameters:params
                                                  constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:d name:@"userfile" fileName:self.fileName mimeType:@"audio/x-aac"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS: SEND AUDIO");
        if (callback) callback();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL: SEND AUDIO");
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    return YES;
}

- (void)changeFileName {
    self.currentIndex++;
    self.fileName = [NSString stringWithFormat:@"sound%d.aac", self.currentIndex];
}

- (void)send {
    [self sendWithCallback:nil];
}

- (void)sendWithCallback:(SFBroadcastCallback)callback {
    [self changeFileName];
    NSData *data = [NSData dataWithContentsOfFile:self.recordFilePath];
    NSUInteger length = [data length];
    NSRange range;
    range.location = self.lastBytes + 1;
    range.length = (length - range.location);
    if (range.length > 0) {
        self.lastBytes = length - 1;
        NSData *dataToSend = [data subdataWithRange:range];
        [self sendAudioToServer:dataToSend withCallback:callback];
    }
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"Audio Record has stopped");
}

- (void)stop {
    if (self.isRecording) {
        [self.audioController removeInputReceiver:self.audioRecorder];
        [self.audioController removeOutputReceiver:self.audioRecorder];
        [self.audioRecorder finishRecording];
        
        [self.timer invalidate];
        [self sendWithCallback:^{
            [self sendStopRequestToServer];
        }];
        
        self.isRecording = NO;
        [self stopMusic];
    }
}

@end
