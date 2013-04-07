//
//  SFChatViewController.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 6/4/13.s
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"
#import "SFChatMessageViewController.h"

@protocol SFChatViewControllerProtocol<NSObject>

@end

@interface SFChatViewController : BaseViewController<SFChatMessageViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *chatTextField;

- (IBAction)chatTextEditBeginned:(id)sender;
- (IBAction)chatTextEditEnded:(id)sender;

- (id)initChatViewWithDelegate:(id)delegate;

@end
