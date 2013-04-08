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

@interface SFChatViewController ()

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
    self.chatTextField.frame = CGRectMake(self.chatTextField.frame.origin.x, kSFScreenHeight - kSFKeyboardHeight - self.chatTextField.frame.size.height - 35,
                                self.chatTextField.frame.size.width, self.chatTextField.frame.size.height);
}

- (IBAction)chatTextEditEnded:(id)sender {
    self.chatTextField.frame = CGRectMake(self.chatTextField.frame.origin.x, kSFChatTextFrameY,
                                          self.chatTextField.frame.size.width, self.chatTextField.frame.size.height);
}

- (id)initChatViewWithDelegate:(id)delegate {
    self = [self initWithNib];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.chatTextField.frame = CGRectMake(self.chatTextField.frame.origin.x, self.chatTextField.frame.origin.y,
                                          self.chatTextField.frame.size.width, 40);
    
    //Test
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Richard", @"Lorem ipsum dolor sit amet", nil]
                                                                   forKeys:[NSArray arrayWithObjects:@"userName", @"message", nil]];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Richard", @"Lorem ipsum dolor sit amet", nil]
                                                                   forKeys:[NSArray arrayWithObjects:@"userName", @"message", nil]];
    
    self.messagesData = [NSMutableArray arrayWithObjects:dict, dict2, nil];
    self.chatTableViewController = [[SFChatTableViewController alloc] initWithData:self.messagesData];
    self.chatTableViewController.tableView.frame = CGRectMake(42, 80, 440, 560);

    [self.view addSubview:self.chatTableViewController.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setChatTextField:nil];
    [super viewDidUnload];
}
@end
