//
//  RecordViewController.m
//  TestAudio
//
//  Created by Le Viet Tien on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "RecordViewController.h"
#import <CoreMedia/CoreMedia.h>
#import "AFNetworking.h"

@interface RecordViewController ()
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) int count;
@property (nonatomic) NSUInteger lastBytes;
@end

@implementation RecordViewController

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
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Record";
    [self.navigationController setNavigationBarHidden:NO];
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stopButton.frame = CGRectMake(50, 50, 100, 50);
    [stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:stopButton];

}

- (void)viewDidDisappear:(BOOL)animated {
    [self stop];
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.count = -1;
    self.lastBytes = -1;
    [self record];
}

- (BOOL)sendCreateRequestToServer {    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://54.251.250.31"]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.username, [PFUser currentUser].sessionToken, nil]
                                                       forKeys:[NSArray arrayWithObjects:@"username", @"session_token", nil]];
    NSMutableURLRequest *requets = [client requestWithMethod:@"POST" path:@"/create.php" parameters:params];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requets];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL: CREATE REQUEST");
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    return YES;
}

- (BOOL)sendStopRequestToServer {
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://54.251.250.31"]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.username, [PFUser currentUser].sessionToken, nil]
                                                       forKeys:[NSArray arrayWithObjects:@"username", @"session_token", nil]];
    NSMutableURLRequest *requets = [client requestWithMethod:@"POST" path:@"/stop.php" parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requets];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL: STOP REQUEST");
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    return YES;
}

- (void)record
{
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"recordedfile.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
                                    [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:40000], AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:22050.0], AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    self.audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    self.audioRecorder.delegate = self;
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
        
    } else {
        [self.audioRecorder prepareToRecord];
        [self sendCreateRequestToServer];
    }
    
    [self.audioRecorder record];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0f
                                                  target:self
                                                selector:@selector(send)
                                                userInfo:nil
                                                 repeats:YES];
}

- (BOOL)sendAudioToServer :(NSData *)data {
    NSData *d = [NSData dataWithData:data];
    //now you'll just have to send that NSData to your server
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://54.251.250.31"]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:self.username forKey:@"username"];
    NSMutableURLRequest *myRequest = [client multipartFormRequestWithMethod:@"POST" path:@"/upload.php" parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:d name:@"userfile" fileName:self.fileName mimeType:@"audio/x-caf"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCESS");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL: SEND AUDIO");
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    return YES;
}

- (void)changeFileName {
    self.count++;
    self.fileName = [NSString stringWithFormat:@"sound%d.caf", self.count];
}

- (void)send {
    [self changeFileName];
    NSLog(@"stoped");
    NSLog(@"%@", self.audioRecorder.url);
    NSData *data = [NSData dataWithContentsOfURL:self.audioRecorder.url];
    
    NSUInteger length = [data length];
    NSLog(@"LENGTH = %lu", (unsigned long)length);
    NSRange range;
    range.location = self.lastBytes + 1;
    range.length = (length - range.location);
    NSLog(@"LOCATION = %lu", (unsigned long)range.location);
    NSLog(@"LENGTH TO SEND = %lu", (unsigned long)range.length);
    self.lastBytes = length - 1;
    NSData *dataToSend = [data subdataWithRange:range];
    [self sendAudioToServer:dataToSend];
    
//    [self sendAudioToServer:data];
    NSLog(@"stoped sent and restarted");
}


-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
//    NSLog(@"stoped");
//    NSLog(@"%@", recorder.url);
//    NSData *data = [NSData dataWithContentsOfURL:recorder.url];
//    [self sendAudioToServer:data];
//    NSLog(@"stoped sent and restarted");
    
    NSLog(@"AUDIO STOP");
}

- (IBAction)stop:(id)sender {
//    [self.timer invalidate];
//    [self.audioRecorder stop];
    [self stop];
}

- (void)stop {
    [self.timer invalidate];
    [self.audioRecorder stop];
    [self sendStopRequestToServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
