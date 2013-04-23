//
//  MainViewController.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"
#import "SFMetroCanvasViewController.h"
#import "SFSidebarViewController.h"
#import "SFTopbarViewController.h"
#import "SFSettingsMenuViewController.h"

@interface SFHomeViewController : BaseViewController <SFSidebarViewControllerProtocol,
                                                        SFMetroCanvasViewControllerProtocol,
                                                        UISearchBarDelegate>

@property (nonatomic, strong) SFMetroCanvasViewController *trendingCanvasViewController;
@property (nonatomic, strong) SFMetroCanvasViewController *favoriteCanvasViewController;
@property (nonatomic, strong) SFMetroCanvasViewController *recentCanvasViewController;
@property (nonatomic, strong) SFMetroCanvasViewController *searchCanvasViewController;
@property (nonatomic, strong) SFSidebarViewController *sidebarViewController;
@property (nonatomic, strong) SFTopbarViewController *topbarViewController;
@property (nonatomic, strong) SFSettingsMenuViewController *settingsMenuViewController;
@property (nonatomic, strong) UILabel *canvasTitle;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UISearchBar *searchBar;

@end
