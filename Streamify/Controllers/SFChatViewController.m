//
//  SFChatViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "SFChatViewController.h"
#import "SFChatMessageViewController.h"

@interface SFChatViewController ()
@property (nonatomic, weak) id<SFChatViewControllerProtocol> delegate;
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
    self.delegate = delegate;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.chatTextField.frame = CGRectMake(self.chatTextField.frame.origin.x, self.chatTextField.frame.origin.y,
                                          self.chatTextField.frame.size.width, 40);
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
