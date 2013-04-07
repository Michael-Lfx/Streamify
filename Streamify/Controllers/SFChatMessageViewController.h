//
//  SFChatMessageViewController.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"

@protocol SFChatMessageViewControllerDelegate <NSObject>

@end

@interface SFChatMessageViewController : BaseViewController

// NSDictionary messageData consists of an UIImage, a NSDate messageTime (if neccessary), a NSString userName and a NSString message

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

- (id)initWithData:(NSDictionary *)data delegate:(id)delegate;

@end
