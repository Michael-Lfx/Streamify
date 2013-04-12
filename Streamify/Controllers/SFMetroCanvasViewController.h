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
- (BOOL)canvasDataSourceIsLoading;

@end


@interface SFMetroCanvasViewController : BaseViewController

@property (nonatomic) SFMetroPullRefreshState canvasState;

- (id)initWithTiles:(NSArray *)tiles delegate:(id)delegate;
- (void)refreshWithTiles:(NSArray *)tiles;

@end
