//
//  SFBroadcasterMainColumnViewController.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "SFSlider.h"
#import "BaseViewController.h"
#import "SFUser.h"

@interface SFBroadcasterMainColumnViewController: BaseViewController

@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *personListeningLabel;
@property (strong, nonatomic) IBOutlet UILabel *personFollowingLabel;
@property (strong, nonatomic) IBOutlet UILabel *channelInfoLabel;

@property (strong, nonatomic) IBOutlet UIButton *controlButton;

@property (strong, nonatomic) IBOutlet UIButton *effect1Button;
@property (strong, nonatomic) IBOutlet UIButton *effect2Button;
@property (strong, nonatomic) IBOutlet UIButton *effect3Button;
@property (strong, nonatomic) IBOutlet UIButton *effect4Button;

@property (strong, nonatomic) IBOutlet SFSlider *volumeSlider;

- (id)initBroadcasterMainColumnWithUser:(SFUser *)user;

- (IBAction)controlButtonPressed:(id)sender;
- (IBAction)volumeSliderChanged:(id)sender;

@end
