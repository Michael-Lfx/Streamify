//
//  SFTopbarViewController.h
//  Streamify
//
//  Created by Le Minh Tu on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"
#import "SFSlider.h"

@interface SFTopbarViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIButton *controlButton;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet SFSlider *volumeSlider;

//- (id)initTopbarWithDelegate:(id)delegate channelState:(SFChannelState)channelState;
- (IBAction)volumeSliderChanged:(id)sender;
- (IBAction)controlButtonPressed:(id)sender;

@end
