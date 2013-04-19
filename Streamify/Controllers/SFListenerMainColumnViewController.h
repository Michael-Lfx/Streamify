//
//  SFListenerMainColumnViewController.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "BaseViewController.h"
#import "SFUser.h"

@interface SFListenerMainColumnViewController: BaseViewController

@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *personListeningLabel;
@property (strong, nonatomic) IBOutlet UILabel *personFollowingLabel;
@property (strong, nonatomic) IBOutlet UILabel *channelInfoLabel;

@property (strong, nonatomic) IBOutlet UIButton *controlButton;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;

- (id)initListenerMainColumnWithUser:(SFUser *)user;

- (IBAction)controlButtonPressed:(id)sender;
- (IBAction)volumeSliderChanged:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)followButtonPressed:(id)sender;

@end
