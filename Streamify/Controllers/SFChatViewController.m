//
//  SFChatViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "SFUIDefaultTheme.h"
#import "SFChatViewController.h"
#import "SFChatTableViewController.h"

@interface SFChatViewController () <UITextFieldDelegate>
@property (nonatomic, strong) NSDate *lastUpdateTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL doneFetching;
@end

@implementation SFChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)chatTextEditBeginned:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.chatTableViewController.tableView.frame = CGRectMake(kSFChatTableFrameX, kSFChatTableFrameY, kSFChatTableFrameW, kSFChatTableFrameH - kSFKeyboardHeight);
        self.chatTextField.frame = CGRectMake(self.chatTextField.frame.origin.x, kSFScreenHeight - kSFKeyboardHeight - self.chatTextField.frame.size.height - 35,
                                              self.chatTextField.frame.size.width, self.chatTextField.frame.size.height);
        self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, kSFScreenHeight - kSFKeyboardHeight - self.sendButton.frame.size.height - 35,
                                           self.sendButton.frame.size.width, self.sendButton.frame.size.height);
    }];
}

- (IBAction)chatTextEditEnded:(id)sender {
    self.chatTableViewController.tableView.frame = CGRectMake(kSFChatTableFrameX, kSFChatTableFrameY, kSFChatTableFrameW, kSFChatTableFrameH);
    self.chatTextField.frame = CGRectMake(self.chatTextField.frame.origin.x, kSFChatTextFrameY,
                                          self.chatTextField.frame.size.width, self.chatTextField.frame.size.height);
    self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, kSFChatTextFrameY,
                                          self.sendButton.frame.size.width, self.sendButton.frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)sendButtonPressed:(id)sender {
    NSString *text = self.chatTextField.text;
    NSString *trimmedString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *name = [SFSocialManager sharedInstance].currentUser.name;
    NSString *pictureURL = [SFSocialManager sharedInstance].currentUser.pictureURL;
    
    if (trimmedString.length > 0) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.channel, kMessageChannel,
                              name, kMessageName,
                              pictureURL, kMessagePictureURL,
                              trimmedString, kMessageText,
//                              [NSDate date], kMessageTime,
                              nil];
        
        [[SFSocialManager sharedInstance] postMessage:dict withCallback:^(id returnedObject) {
            if ([[returnedObject objectForKey:kOperationResult] isEqual: OPERATION_SUCCEEDED]){
                NSLog(@"Succeeded sending: %@", [returnedObject objectForKey:kResultMessage]);
            }
        }];
    }

    self.chatTextField.text = @"";
    [self.chatTextField resignFirstResponder];
}

- (id)initChatViewWithDelegate:(id)delegate {
    if (self = [self initWithNib]) {
        self.delegate = delegate;
        self.chatTextField.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SFUIDefaultTheme themeButton:self.sendButton];
    
    self.chatTextField.frame = CGRectMake(self.chatTextField.frame.origin.x, self.chatTextField.frame.origin.y,
                                          self.chatTextField.frame.size.width, kSFChatTextFrameH);
    self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, self.chatTextField.frame.origin.y,
                                       self.sendButton.frame.size.width, kSFChatTextFrameH);
    
//    self.chatTableViewController = [[SFChatTableViewController alloc] init];
    self.chatTableViewController = [[SFChatTableViewController alloc] initWithNibName:@"SFChatTableViewController" bundle:[NSBundle mainBundle]];
    self.chatTableViewController.tableView.frame = CGRectMake(kSFChatTableFrameX, kSFChatTableFrameY, kSFChatTableFrameW, kSFChatTableFrameH);

    [self.view addSubview:self.chatTableViewController.tableView];
    
    self.doneFetching = YES;
    self.lastUpdateTime = [NSDate date];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateMessages) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)updateMessages {
    if (!self.doneFetching) return;
    self.doneFetching = NO;
    [[SFSocialManager sharedInstance] fetchChannelMessages:self.channel
                                               lastUpdated:self.lastUpdateTime
                                              withCallback:^(id returnedObject) {
                                                  if ([[returnedObject objectForKey:kOperationResult] isEqual:OPERATION_SUCCEEDED]) {
                                                      NSArray *newMessages = [returnedObject objectForKey:kResultNewMessages];
                                                      if (newMessages.count > 0) {
                                                          [self.chatTableViewController.messagesData removeAllObjects];
                                                          newMessages = [[newMessages reverseObjectEnumerator] allObjects];
                                                          for (SFMessage *message in newMessages) {
                                                              if ([message.timeCreated laterDate:self.lastUpdateTime]) {
                                                                  [self.chatTableViewController.messagesData addObject:message];
                                                                  self.lastUpdateTime = message.timeCreated;
                                                              }
                                                          }
                                                          
                                                          [self.chatTableViewController.tableView reloadData];
                                                      }
                                                  }
                                                  self.doneFetching = YES;
                                              }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setChatTextField:nil];
    [self setSendButton:nil];
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated{
    
}
@end
