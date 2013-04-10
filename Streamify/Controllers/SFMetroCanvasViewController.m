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
#import "SFMetroTileView.h"
#import "SFTileModel.h"
#import "SFListenerViewController.h"

@interface SFMetroCanvasViewController ()

@property (nonatomic, strong) id <SFMetroCanvasViewControllerProtocol> delegate;
@property (nonatomic, strong) NSMutableArray *pageViews;

@end

@implementation SFMetroCanvasViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDelegate:(id)delegate {
    self = [self initWithNib];
    self.delegate = delegate;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setup) name:kUpdateMeSuccessNotification object:nil];
}

- (void)setup {
    [self initTiles];
    self.pageViews = [[NSMutableArray alloc] init];
    NSInteger numOfPages = self.tiles.count/kNumTilesPerPage + 1;
    for (NSInteger i = 0; i < numOfPages; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.01f];
    
    if (kMetroDebug) {
        self.view.layer.borderColor = [UIColor redColor].CGColor;
        self.view.layer.borderWidth = 3.0f;
        self.scrollView.layer.borderColor = [UIColor greenColor].CGColor;
        self.scrollView.layer.borderWidth = 1.0f;
    }
    
    [self loadVisiblePages];
}

- (void)initTiles
{
    /*
    UIImage *image;
    NSString *imageName, *coverName;
    SFTileModel *tile;
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < 100; ++i) {
        coverName = [NSString stringWithFormat:@"Cover %d", i];
        imageName = [NSString stringWithFormat:@"%d.JPG", i];
        image = [UIImage imageNamed:imageName];
        tile = [[SFTileModel alloc] initWithName:coverName andCover:image];
        [temp addObject:tile];
    }
    self.tiles = [NSArray arrayWithArray:temp];
     */
    
    NSMutableArray *temp = [NSMutableArray array];
    for (SFUser *user in [SFSocialManager sharedInstance].currentUser.followings) {
        SFTileModel *tile = [[SFTileModel alloc] initWithUser:user];
        [temp addObject:tile];
    }
    self.tiles = [NSMutableArray arrayWithArray:temp];
    NSLog(@"NUMBER OF TILES = %lu", (unsigned long)[self.tiles count]);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageViews.count, pagesScrollViewSize.height);
    
    [self loadVisiblePages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ScrollView helpers

- (void)loadVisiblePages
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    for (NSInteger i = firstPage; i <= lastPage; ++i) {
        [self loadPage:i];
    }
    
    [self purgePage:(firstPage - 1)];
    [self purgePage:(lastPage + 1)];
    
    //    for (NSInteger i = 0; i < firstPage; ++i) {
    //        [self purgePage:i];
    //    }
    //    for (NSInteger i = lastPage + 1; i < self.tiles.count; ++i) {
    //        [self purgePage:i];
    //    }
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
    NSInteger firstTileIndex = page * kNumTilesPerPage;
    NSInteger lastTileIndex = firstTileIndex + kNumTilesPerPage - 1;
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
    for (NSInteger i = 0; i < tiles.count; ++i) {
        SFTileModel *tile = (SFTileModel *)[tiles objectAtIndex:i];
        SFMetroTileView *tileView = [[[NSBundle mainBundle] loadNibNamed:kMetroTileViewNibName owner:self options:nil] lastObject];
        [tileView setTitle:[NSString stringWithFormat:@"%@ %@", tile.user.name ,tile.user.objectID]];
        [tileView setPictureLink:tile.user.pictureURL];
        tileView.tag = i;
//        [tileView setCover:tile.cover];
        UITapGestureRecognizer *tapOnTileRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openChannelListener:)];
        tapOnTileRecognizer.numberOfTapsRequired = 1;
        tapOnTileRecognizer.numberOfTouchesRequired = 1;
        [tileView addGestureRecognizer:tapOnTileRecognizer];
        
        NSInteger row = i / kNumTilesPerRow;
        NSInteger column = i % kNumTilesPerRow;
        CGRect frame = tileView.frame;
        if (column != 0) {
            frame.origin.x = column * (tileView.frame.size.width + kPaddingBetweenTiles);
        }
        if (row != 0) {
            frame.origin.y = row * (tileView.frame.size.height + kPaddingBetweenTiles);
        }
        tileView.frame = frame;
        [pageView addSubview:tileView];
    }
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadVisiblePages];
}

#pragma mark - Gesture Handlers

- (void)openChannelListener:(UIGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
//        SFListenerViewController *listenerViewController = [[SFListenerViewController alloc] init];
//        [self presentViewController:listenerViewController animated:YES completion:nil];
//        [self.navigationController pushViewController:listenerViewController animated:YES];
//        [self.delegate tilePressed:tapRecognizer.view];
        [self.delegate tilePressed:[self.tiles objectAtIndex:tapRecognizer.view.tag]];
    }
}

@end

