//
//  SFMainColumnViewController.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "BaseViewController.h"

@protocol SFMainColumnViewControllerProtocol <NSObject>
- (void)controlButtonPressed:(id)sender;
@end

@interface SFMainColumnViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *personListeningLabel;
@property (strong, nonatomic) IBOutlet UILabel *personFollowingLabel;
@property (strong, nonatomic) IBOutlet UILabel *channelInfoLabel;

@property (strong, nonatomic) IBOutlet UIView *listenerButtonsView;
@property (strong, nonatomic) IBOutlet UIView *broadcasterButtonsView;

@property (strong, nonatomic) IBOutlet UIButton *controlButton;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;

@property (strong, nonatomic) IBOutlet UIButton *effect1Button;
@property (strong, nonatomic) IBOutlet UIButton *effect2Button;
@property (strong, nonatomic) IBOutlet UIButton *effect3Button;
@property (strong, nonatomic) IBOutlet UIButton *effect4Button;

- (id)initMainColumnWithOption:(SFMainColumnType)mainColumnType delegate:(id)delegate;
- (IBAction)controlButtonPressed:(id)sender;

@end
