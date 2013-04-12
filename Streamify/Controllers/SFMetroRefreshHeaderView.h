//
//  SFMetroRefreshHeaderView.h
//  Streamify
//
//  Created by Le Minh Tu on 4/11/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SFMetroPullRefreshPulling = 0,
    SFMetroPullRefreshNormal,
    SFMetroPullRefreshLoading,
} SFMetroPullRefreshState;

//@class SFMetroRefreshHeaderView;
//
//@protocol SFMetroRefreshHeaderDelegate <NSObject>
//
//- (void)refreshHeaderDidTriggerRefresh:(SFMetroRefreshHeaderView *)view;
//- (BOOL)refreshHeaderDataSourceIsLoading:(SFMetroRefreshHeaderView *)view;
//
//@end

@interface SFMetroRefreshHeaderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *status;
@property (nonatomic) SFMetroPullRefreshState state;

//@property (nonatomic, retain) id<SFMetroRefreshHeaderDelegate> delegate;
//
//- (void)canvasScrollViewDidScroll:(UIScrollView *)scrollView;
//- (void)canvasScrollViewDidEndDragging:(UIScrollView *)scrollView;
//- (void)canvasScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
