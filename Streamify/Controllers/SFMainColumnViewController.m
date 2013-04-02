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
    self = [[SFMainColumnViewController alloc] initWithNib];
    self.mainColumnType = mainColumnType;
    self.delegate = delegate;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.coverImageView.bounds];
    self.coverImageView.layer.masksToBounds = NO;
    self.coverImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.coverImageView.layer.shadowRadius = 4.0f;
    self.coverImageView.layer.shadowOpacity = 0.5f;
    self.coverImageView.layer.shadowPath = shadowPath.CGPath;
    
    [SFUIDefaultTheme themeButton:self.followButton];
    [SFUIDefaultTheme themeButton:self.shareButton];
    [SFUIDefaultTheme themeButton:self.effect1Button];
    [SFUIDefaultTheme themeButton:self.effect2Button];
    [SFUIDefaultTheme themeButton:self.effect3Button];
    [SFUIDefaultTheme themeButton:self.effect4Button];
    
    if (self.mainColumnType == kSFMainColumnListener) {
        self.broadcasterButtonsView.hidden = YES;
    } else if (self.mainColumnType == kSFMainColumnBroadcaster) {
        self.listenerButtonsView.hidden = YES;
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
    [super viewDidUnload];
}

@end
