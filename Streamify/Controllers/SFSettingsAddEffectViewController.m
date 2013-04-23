//
//  SFSettingsViewController.m
//  Streamify
//
//  Created by Rahij Ramsharan on 4/21/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFSettingsAddEffectViewController.h"

@interface SFSettingsAddEffectViewController ()

@property NSTimer *timer;
@property AVAudioRecorder *audioRecorder;
@property AVAudioPlayer *audioPlayer;

@end


@implementation SFSettingsAddEffectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Settings";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Effects Library";
    self.contentSizeForViewInPopover =  CGSizeMake(480, 380);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)record {
    
    if([self.effectName.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter an effect name!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        return;
    }

    NSString *docsDir = [[SFStorageManager sharedInstance] directoryForEffectFiles];
    
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:self.effectName.text];
    soundFilePath = [soundFilePath stringByAppendingString:@".caf"];
    NSLog(@"%@", soundFilePath);
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    self.audioRecorder = [[AVAudioRecorder alloc]
                          initWithURL:[NSURL fileURLWithPath:soundFilePath]
                          settings:recordSettings
                          error:&error];
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
        
    } else {
        NSLog(@"successfully prepared to record effect");
        [self.audioRecorder prepareToRecord];
    }
    
    // Start the recording process
    NSLog(@"Recording");
    [self.audioRecorder record];
    self.isRecording = YES;
    [self startTimer];
}

- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0f
                                                  target:self
                                                selector:@selector(stop)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stop {
    if (self.isRecording) {
        [self.audioRecorder stop];
        [self.timer invalidate];        
        self.isRecording = NO;
    }
}

-(void)play{
    if (!self.isRecording) {
        NSError *error;
        NSLog(@"play");
        
        self.audioPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:self.audioRecorder.url
                       error:&error];
        
        if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        else
            [self.audioPlayer play];
    }
}

-(IBAction)recordPressed:(id)sender{
    [self record];
}

- (IBAction)stopPressed:(id)sender {
    [self stop];
}

- (IBAction)playPressed:(id)sender {
    [self play];
}

- (IBAction)effectNameEntered:(id)sender {
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
