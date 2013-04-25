//
//  SFPlaylistControlPanelViewController.h
//  Streamify
//
//  Created by Le Minh Tu on 4/22/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"
#import "SFSlider.h"

@class SFPlaylistViewController;

@protocol SFPlaylistControlPanelDelegate <NSObject>

@required
- (void)managePlaylistButtonPressed;
- (void)playButtonPressed;


@end

@protocol SFPlayListControlDataSourceProtocol <NSObject>

- (SFSong *)currentSelectedSong;

@end


@interface SFPlaylistControlPanelViewController : BaseViewController

@property (nonatomic, strong) SFPlaylistViewController *playlistVC;
@property (weak, nonatomic) IBOutlet UIButton *controlButton;
@property (strong, nonatomic) IBOutlet UIButton *manageButton;
@property (strong, nonatomic) IBOutlet SFSlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) id <SFPlayListControlDataSourceProtocol> datasource;
@property (nonatomic, strong) SFSong *currentSong;

- (id)initWithDelegate:(id)delegate;
- (IBAction)managePlaylistButtonPressed:(id)sender;
- (IBAction)playButtonPressed:(id)sender;
- (IBAction)volumSliderChanged:(id)sender;

@end
