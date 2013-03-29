//
//  RecordViewController.h
//  TestAudio
//
//  Created by Le Viet Tien on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordViewController : UIViewController<AVAudioRecorderDelegate>
- (void)send;
@property (nonatomic, strong) NSString *username;
@end
