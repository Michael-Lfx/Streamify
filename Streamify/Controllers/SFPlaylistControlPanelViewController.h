//
//  SFPlaylistControlPanelViewController.h
//  Streamify
//
//  Created by Le Minh Tu on 4/22/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"

@protocol SFPlaylistControlPanelDelegate <NSObject>

@required
- (void)managePlaylistButtonPressed;
- (void)playButtonPressed;
- (void)nextButtonPressed;
- (void)backButtonPressed;

@end


@interface SFPlaylistControlPanelViewController : BaseViewController

- (id)initWithDelegate:(id)delegate;
- (IBAction)managePlaylistButtonPressed:(id)sender;
- (IBAction)playButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end
