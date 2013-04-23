//
//  SFPlaylistControlPanelViewController.h
//  Streamify
//
//  Created by Le Minh Tu on 4/22/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"

@class SFPlaylistViewController;

@protocol SFPlaylistControlPanelDelegate <NSObject>

@required
- (void)managePlaylistButtonPressed;
- (void)playButtonPressed;

@end

@interface SFPlaylistControlPanelViewController : BaseViewController

@property (nonatomic, strong) SFPlaylistViewController *playlistVC;
@property (weak, nonatomic) IBOutlet UIButton *controlButton;
@property (strong, nonatomic) IBOutlet UIButton *manageButton;

@property (nonatomic, strong) SFSong *currentSong;

- (id)initWithDelegate:(id)delegate;
- (IBAction)managePlaylistButtonPressed:(id)sender;
- (IBAction)playButtonPressed:(id)sender;

@end
