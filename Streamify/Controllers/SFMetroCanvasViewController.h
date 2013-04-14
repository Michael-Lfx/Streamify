//
//  SFMetroCanvasViewController.h
//  Streamify
//
//  Created by Le Minh Tu on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"
#import "SFMetroRefreshHeaderView.h"
#import "SFMetroTileView.h"

@protocol SFMetroCanvasViewControllerProtocol <NSObject>

- (void)tileDidTapped:(SFUser *)user;
- (void)canvasDidTriggeredToRefresh;

@end


@interface SFMetroCanvasViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *canvasInitIndicator;

- (id)initWithTiles:(NSArray *)tiles emptyCanvasMessage:(NSString *)message delegate:(id)delegate;
- (void)refreshWithTiles:(NSArray *)tiles;
- (void)canvasScrollViewDataSourceDidFinishedLoading;

@end
