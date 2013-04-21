//
//  SFMetroCanvasViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SFMetroConstants.h"
#import "SFMetroCanvasViewController.h"
#import "SFMetroRefreshHeaderView.h"
#import "SFMetroTileView.h"

@interface SFMetroCanvasViewController ()

@property (nonatomic, strong) id <SFMetroCanvasViewControllerProtocol> delegate;
@property (nonatomic, strong) NSArray *tiles;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *notificationLabel;
@property (nonatomic, strong) SFMetroRefreshHeaderView *refreshHeaderView;
@property (nonatomic) SFMetroPullRefreshState canvasState;
@property (nonatomic) BOOL canvasLoading;
@property (nonatomic, strong) NSString *emptyCanvasMessage;

@end


@implementation SFMetroCanvasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTiles:(NSArray *)tiles
 emptyCanvasMessage:(NSString *)message
           delegate:(id)delegate {
    self = [self initWithNib];
    if (self) {
        self.tiles = tiles;
        self.emptyCanvasMessage = message;
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
	// Do any additional setup after loading the view.
    [self resetPageViews];
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.01f];
    [self loadVisiblePages];
    
    // Add header view
    self.refreshHeaderView = [[[NSBundle mainBundle] loadNibNamed:kMetroRefreshHeaderViewNibName owner:self options:nil] lastObject];
    CGSize refreshHeaderSize = self.refreshHeaderView.frame.size;
    self.refreshHeaderView.frame = CGRectMake(-refreshHeaderSize.width, 0, refreshHeaderSize.width, refreshHeaderSize.height);
    [self.scrollView addSubview:self.refreshHeaderView];
    
    // Add empty message
    self.notificationLabel.text = self.emptyCanvasMessage;
    self.notificationLabel.hidden = YES;
    
    if (kMetroDebug) {
        self.view.layer.borderColor = [UIColor redColor].CGColor;
        self.view.layer.borderWidth = 3.0f;
        self.scrollView.layer.borderColor = [UIColor greenColor].CGColor;
        self.scrollView.layer.borderWidth = 1.0f;
    }
}

- (void)resetPageViews {
    self.pageViews = [[NSMutableArray alloc] init];
    NSInteger numOfPages = ((int)self.tiles.count - 1)/kMetroNumTilesPerPage + 1;
    for (NSInteger i = 0; i < numOfPages; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
}

- (void)resetScrollViewContentSize {
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageViews.count, pagesScrollViewSize.height);
}

// The contenSize initialization should go here instead of viewDidLoad
// The reason you can’t is that the view size isn’t definitely known until
// viewWillAppear:, and since you use the size of scrollView when calculating
// the minimum zoom, things might go wrong if we do it in viewDidLoad.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self resetScrollViewContentSize];
    [self loadVisiblePages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setters

- (void)setCanvasState:(SFMetroPullRefreshState)newCanvasState
{
    self.refreshHeaderView.state = newCanvasState;
    _canvasState = newCanvasState;
}


#pragma mark - Canvas Refresh

- (void)reset
{
    // Reset canvas' scrollview
    NSInteger currentPage = [self getCurrentPage];
    [self purgePage:(currentPage - 1)];
    [self purgePage:currentPage];
    [self purgePage:(currentPage + 1)];
    [self resetPageViews];
    [self resetScrollViewContentSize];
}

- (void)clear
{
    self.tiles = [NSArray array];
    self.notificationLabel.hidden = YES;
    [self reset];
}

- (void)refreshWithTiles:(NSArray *)tiles
{
    self.canvasLoading = NO;
    
    self.tiles = tiles;
    if (self.tiles.count == 0) {
        self.notificationLabel.hidden = NO;
    } else {
        self.notificationLabel.hidden = YES;
    }
    
    [self reset];
    
    // Refresh
    [self performSelectorOnMainThread:@selector(refreshCanvas) withObject:nil waitUntilDone:NO];
}

- (void)refreshCanvas
{
    if (self.scrollView.isDragging && self.scrollView.decelerating) {
        [self stopCanvasScrolling];
    }
    [UIView transitionWithView:self.scrollView
                      duration:0.5f
                       options:UIViewAnimationOptionShowHideTransitionViews
                    animations:^{
                        self.scrollView.contentOffset = CGPointMake(0, 0);
                        self.scrollView.contentInset = UIEdgeInsetsZero;
                        self.canvasState = SFMetroPullRefreshNormal;
                    } completion:^(BOOL finished) {
                        self.scrollView.pagingEnabled = YES;
                        [self loadVisiblePages];
                        [UIView transitionWithView:self.scrollView
                                          duration:kMetroRefreshHeaderOnCanvasRefreshAnimationDuration
                                           options:UIViewAnimationOptionTransitionCrossDissolve
                                        animations:^{
                                        }
                                        completion:^(BOOL finished) {
                                        }];
                    }];
    
    
    
}

- (void)stopCanvasScrolling
{
    CGPoint offset = self.scrollView.contentOffset;
    offset.x -= 1.0;
    offset.y -= 1.0;
    [self.scrollView setContentOffset:offset animated:NO];
    offset.x += 1.0;
    offset.y += 1.0;
    [self.scrollView setContentOffset:offset animated:NO];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadVisiblePages];
    if (self.canvasState == SFMetroPullRefreshLoading) {
        CGFloat offset = MAX(-scrollView.contentOffset.x, 0);
        offset = MIN(offset, kMetroPullToRefreshOffset);
        scrollView.contentInset = UIEdgeInsetsMake(0, offset, 0, 0);
    } else if (scrollView.isDragging) {
        if (self.canvasState == SFMetroPullRefreshPulling
            && scrollView.contentOffset.x > -kMetroPullToRefreshOffsetLimit
            && scrollView.contentOffset.x < 0
            && !self.canvasLoading) {
            self.canvasState = SFMetroPullRefreshNormal;
        } else if (self.canvasState == SFMetroPullRefreshNormal
                   && scrollView.contentOffset.x < -kMetroPullToRefreshOffsetLimit
                   && !self.canvasLoading) {
            self.canvasState = SFMetroPullRefreshPulling;
        }
        
        if (scrollView.contentInset.left != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x <= -kMetroPullToRefreshOffsetLimit
        && !self.canvasLoading) {
        self.canvasLoading = YES;
        scrollView.pagingEnabled = NO;
        self.canvasState = SFMetroPullRefreshLoading;
        [UIView animateWithDuration:kMetroRefreshHeaderOnReleaseRetractAnimationDuration animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
            scrollView.contentInset = UIEdgeInsetsMake(0, kMetroPullToRefreshOffset, 0, 0);
        }];
        [self.delegate canvasDidTriggeredToRefresh];
    }
}

#pragma mark - Pull To Refresh public helpers

- (void)canvasScrollViewDataSourceDidFinishedLoading
{
    
}


#pragma mark - ScrollView helpers for paging

- (NSInteger)getCurrentPage
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    return (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
}

- (void)loadVisiblePages
{
    NSInteger page = [self getCurrentPage];
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    for (NSInteger i = firstPage; i <= lastPage; ++i) {
        [self loadPage:i];
    }
    
    [self purgePage:(firstPage - 1)];
    [self purgePage:(lastPage + 1)];
}

- (void)purgePage:(NSInteger)page
{
    if (page < 0 || page >= self.pageViews.count) {
        return;
    }
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull *)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)loadPage:(NSInteger)page
{
    if (page < 0 || page >= self.pageViews.count) {
        return;
    }
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull *)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0;
        
        NSArray *childrenTiles = [self getChildrenTilesOfPage:page];
        UIView *newPageView = [[UIView alloc] initWithFrame:frame];
        [self addTiles:childrenTiles toPageView:newPageView];
        [self.scrollView addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (NSArray *)getChildrenTilesOfPage:(NSInteger)page
{
    NSMutableArray *childrenTiles = [NSMutableArray array];
    NSInteger firstTileIndex = page * kMetroNumTilesPerPage;
    NSInteger lastTileIndex = firstTileIndex + kMetroNumTilesPerPage - 1;
    if (lastTileIndex >= self.tiles.count) {
        lastTileIndex = self.tiles.count - 1;
    }
    
    for (NSInteger i = firstTileIndex; i <= lastTileIndex; ++i) {
        [childrenTiles addObject:[self.tiles objectAtIndex:i]];
    }
    
    return childrenTiles;
}

- (void)addTiles:(NSArray *)tiles toPageView:(UIView *)pageView
{
    for (int i = 0; i < tiles.count; i++) {
        SFUser *user = (SFUser *)[tiles objectAtIndex:i];
        SFMetroTileView *tileView = [[SFMetroTileView alloc] initWithUser:user];
        UITapGestureRecognizer *tapOnTileRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileDidTapped:)];
        tapOnTileRecognizer.numberOfTapsRequired = 1;
        tapOnTileRecognizer.numberOfTouchesRequired = 1;
        [tileView addGestureRecognizer:tapOnTileRecognizer];
        
        NSInteger row = i / kMetroNumTilesPerRow;
        NSInteger column = i % kMetroNumTilesPerRow;
        CGRect frame = tileView.frame;
        if (column != 0) {
            frame.origin.x = column * (tileView.frame.size.width + kMetroPaddingBetweenTiles);
        }
        if (row != 0) {
            frame.origin.y = row * (tileView.frame.size.height + kMetroPaddingBetweenTiles);
        }
        tileView.frame = frame;
        [pageView addSubview:tileView];
    }    
}


#pragma mark - Gesture Handlers

- (void)tileDidTapped:(UIGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        SFMetroTileView *tileView = (SFMetroTileView *)tapRecognizer.view;
        [self.delegate tileDidTapped:tileView.user];
    }
}

- (void)viewDidUnload {
    [self setCanvasInitIndicator:nil];
    [self setNotificationLabel:nil];
    [super viewDidUnload];
}

@end

