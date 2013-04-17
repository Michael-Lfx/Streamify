//
//  SFAudioSession.h
//  Streamify
//
//  Created by Le Minh Tu on 4/17/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFAudioSession : NSObject

+ (SFAudioSession *)sharedInstance;
- (void)setup;

@end
