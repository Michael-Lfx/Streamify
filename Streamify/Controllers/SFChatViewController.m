//
//  SFChatViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "SFChatViewController.h"
#import "SFChatTableViewController.h"

@interface SFChatViewController () <UITextFieldDelegate>

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
    [self.delegate sendText:self.chatTextField.text];
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
    self.chatTextField.frame = CGRectMake(self.chatTextField.frame.origin.x, self.chatTextField.frame.origin.y,
                                          self.chatTextField.frame.size.width, kSFChatTextFrameH);
    self.sendButton.frame = CGRectMake(self.sendButton.frame.origin.x, self.chatTextField.frame.origin.y,
                                       self.sendButton.frame.size.width, kSFChatTextFrameH);
    
    //Test
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Richard", @"Lorem ipsum dolor sit amet", nil]
                                                                   forKeys:[NSArray arrayWithObjects:@"userName", @"message", nil]];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Richard", @"Lorem ipsum dolor sit amet", nil]
                                                                   forKeys:[NSArray arrayWithObjects:@"userName", @"message", nil]];
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Richard", @"Lorem ipsum dolor sit amet", nil]
                                                                    forKeys:[NSArray arrayWithObjects:@"userName", @"message", nil]];
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Richard", @"Lorem ipsum dolor sit amet", nil]
                                                                    forKeys:[NSArray arrayWithObjects:@"userName", @"message", nil]];
    NSMutableDictionary *dict5 = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Richard", @"Lorem ipsum dolor sit amet", nil]
                                                                    forKeys:[NSArray arrayWithObjects:@"userName", @"message", nil]];
    NSMutableDictionary *dict6 = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Richard", @"Lorem ipsum dolor sit amet", nil]
                                                                    forKeys:[NSArray arrayWithObjects:@"userName", @"message", nil]];
    NSMutableDictionary *dict7 = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Richard", @"Lorem ipsum dolor sit amet", nil]
                                                                    forKeys:[NSArray arrayWithObjects:@"userName", @"message", nil]];
    NSMutableDictionary *dict8 = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Richard", @"Lorem ipsum dolor sit amet", nil]
                                                                    forKeys:[NSArray arrayWithObjects:@"userName", @"message", nil]];
    NSMutableDictionary *dict9 = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Richard", @"Lorem ipsum dolor sit amet", nil]
                                                                    forKeys:[NSArray arrayWithObjects:@"userName", @"message", nil]];
    
    self.messagesData = [NSMutableArray arrayWithObjects:dict, dict2, dict3, dict4, dict5, dict6, dict7, dict8, dict9, nil];
    self.chatTableViewController = [[SFChatTableViewController alloc] initWithData:self.messagesData];
    self.chatTableViewController.tableView.frame = CGRectMake(kSFChatTableFrameX, kSFChatTableFrameY, kSFChatTableFrameW, kSFChatTableFrameH);

    [self.view addSubview:self.chatTableViewController.tableView];
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
@end
