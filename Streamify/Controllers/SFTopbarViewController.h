//
//  SFTopbarViewController.h
//  Streamify
//
//  Created by Le Minh Tu on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"

@protocol SFTopbarViewControllerProtocol <NSObject>
- (void)controlButtonPressed:(id)sender;
- (void)volumeSliderChanged:(id)sender;
@end

@interface SFTopbarViewController : BaseViewController

@property (nonatomic) SFChannelState channelState;
@property (nonatomic) NSDictionary *listeningInfo;

@property (strong, nonatomic) IBOutlet UIButton *controlButton;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;

- (id)initTopbarWithDelegate:(id)delegate channelState:(SFChannelState)channelState;
- (IBAction)volumeSliderChanged:(id)sender;
- (IBAction)controlButtonPressed:(id)sender;

@end
