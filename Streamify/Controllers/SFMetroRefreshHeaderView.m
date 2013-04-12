//
//  SFMetroRefreshHeaderView.m
//  Streamify
//
//  Created by Le Minh Tu on 4/11/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFMetroRefreshHeaderView.h"

@interface SFMetroRefreshHeaderView ()

//@property (nonatomic) SFMetroPullRefreshState state;

@end



@implementation SFMetroRefreshHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setState:(SFMetroPullRefreshState)newState
{
    switch (newState) {
        case SFMetroPullRefreshPulling:
            self.status.text = @"Release to refresh...";
            break;
        case SFMetroPullRefreshNormal:
            self.status.text = @"Pull down to refresh";
            break;
        case SFMetroPullRefreshLoading:
            self.status.text = @"Loading...";
            break;
        default:
            break;
    }
    
    _state = newState;
}

//- (void)canvasScrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (self.state == SFMetroPullRefreshLoading) {
//        CGFloat offset = MAX(scrollView.contentOffset.y, 0);
//        offset = MIN(offset, 100);
//        scrollView.contentInset = UIEdgeInsetsMake(0, offset, 0, 0);
//    } else if (scrollView.isDragging) {
//        BOOL loading = NO;
//        
//        if ([self.delegate respondsToSelector:@selector(refreshHeaderDataSourceIsLoading:)]) {
//            loading = [self.delegate refreshHeaderDataSourceIsLoading:self];
//        }
//
//        if (self.state == SFMetroPullRefreshPulling && scrollView.contentOffset.x > -100 && scrollView.contentOffset.x < 0 && !loading) {
//            [self setState:SFMetroPullRefreshPulling];
//        }
//
//        if (scrollView.contentInset.left != 0) {
//            scrollView.contentInset = UIEdgeInsetsZero;
//        }
//    }
//}
//
//- (void)canvasScrollViewDidEndDragging:(UIScrollView *)scrollView
//{
//    BOOL loading = NO;
//    if ([self.delegate respondsToSelector:@selector(refreshHeaderDataSourceIsLoading:)]) {
//        loading = [self.delegate refreshHeaderDataSourceIsLoading:self];
//    }
//    
//    if (scrollView.contentOffset.x <= -100 && !loading) {
//        if ([self.delegate respondsToSelector:@selector(refreshHeaderDidTriggerRefresh:)]) {
//            [self.delegate refreshHeaderDidTriggerRefresh:self];
//        }
//        
//        [self setState:SFMetroPullRefreshLoading];
//        scrollView.contentInset = UIEdgeInsetsMake(0, 100, 0, 0);
//    }
//}
//
//- (void)canvasScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
//    [scrollView setContentInset:UIEdgeInsetsZero];
//    [self setState:SFMetroPullRefreshNormal];
//}

@end
