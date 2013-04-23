//
//  SFChatViewController.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 6/4/13.s
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"

@protocol SFChatViewControllerProtocol<NSObject>
@end

@class SFChatTableViewController;

@interface SFChatViewController : BaseViewController

- (id)initWithChannel:(SFUser *)channel;
- (void)addFooter;

- (IBAction)chatTextEditBeginned:(id)sender;
- (IBAction)chatTextEditEnded:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *arrowImage;
@property (strong, nonatomic) IBOutlet UILabel *slideLabel;
@property (strong, nonatomic) IBOutlet UIView *slideBorder;

@end
