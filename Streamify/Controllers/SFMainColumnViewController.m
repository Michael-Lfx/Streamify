//
//  SFMainColumnViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFMainColumnViewController.h"
#import "SFUIDefaultTheme.h"

@interface SFMainColumnViewController ()

@property (nonatomic, weak) id<SFMainColumnViewControllerProtocol> delegate;
@property (nonatomic) SFMainColumnType mainColumnType;

@end

@implementation SFMainColumnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initMainColumnWithOption:(SFMainColumnType)mainColumnType delegate:(id)delegate
{
    self = [self initWithNib];
    self.mainColumnType = mainColumnType;
    self.delegate = delegate;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(4.0f, 0.0f);
    self.view.layer.shadowOpacity = 0.3f;
    self.view.layer.shadowPath = shadowPath.CGPath;
    
    UIBezierPath *coverShadowPath = [UIBezierPath bezierPathWithRect:self.coverImageView.bounds];
    self.coverImageView.layer.masksToBounds = NO;
    self.coverImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.coverImageView.layer.shadowRadius = 4.0f;
    self.coverImageView.layer.shadowOpacity = 0.5f;
    self.coverImageView.layer.shadowPath = coverShadowPath.CGPath;
    
    [SFUIDefaultTheme themeButton:self.followButton];
    [SFUIDefaultTheme themeButton:self.shareButton];
    [SFUIDefaultTheme themeButton:self.effect1Button];
    [SFUIDefaultTheme themeButton:self.effect2Button];
    [SFUIDefaultTheme themeButton:self.effect3Button];
    [SFUIDefaultTheme themeButton:self.effect4Button];
    
    [SFUIDefaultTheme themeSlider:self.volumeSlider];
    
    if (self.mainColumnType == kSFMainColumnListener) {
        self.broadcasterButtonsView.hidden = YES;
        [self.controlButton setImage:[UIImage imageNamed:@"maincol-icon-stop.png"] forState:UIControlStateNormal];
    } else if (self.mainColumnType == kSFMainColumnBroadcaster) {
        self.listenerButtonsView.hidden = YES;
        [self.controlButton setImage:[UIImage imageNamed:@"maincol-icon-record.png"] forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCoverImageView:nil];
    [self setTimeLabel:nil];
    [self setControlButton:nil];
    [self setFollowButton:nil];
    [self setShareButton:nil];
    [self setPersonListeningLabel:nil];
    [self setPersonFollowingLabel:nil];
    [self setChannelInfoLabel:nil];
    [self setPersonFollowingLabel:nil];
    [self setListenerButtonsView:nil];
    [self setBroadcasterButtonsView:nil];
    [self setEffect1Button:nil];
    [self setEffect2Button:nil];
    [self setEffect3Button:nil];
    [self setEffect4Button:nil];
    [self setVolumeSlider:nil];
    [super viewDidUnload];
}

@end
