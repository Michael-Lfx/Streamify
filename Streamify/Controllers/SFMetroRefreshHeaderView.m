//
//  SFMetroRefreshHeaderView.m
//  Streamify
//
//  Created by Le Minh Tu on 4/11/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFMetroConstants.h"
#import "SFMetroRefreshHeaderView.h"

@interface SFMetroRefreshHeaderView ()

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
        {
            self.status.text = @"Release to refresh...";
            [UIView animateWithDuration:kMetroRefreshHeaderArrowFlipAnimationDuration animations:^{
                self.arrow.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }
            break;
        case SFMetroPullRefreshNormal:
        {
            self.status.text = @"Pull to refresh";
            [UIView animateWithDuration:kMetroRefreshHeaderArrowFlipAnimationDuration animations:^{
                self.arrow.hidden = NO;
                self.arrow.transform = CGAffineTransformIdentity;
            }];
            [self.loadingIndicator stopAnimating];
        }
            break;
        case SFMetroPullRefreshLoading:
        {
            self.status.text = @"Loading...";
            [UIView animateWithDuration:kMetroRefreshHeaderArrowFlipAnimationDuration animations:^{
                self.arrow.hidden = YES;
            }];
            [self.loadingIndicator startAnimating];
        }
            break;
        default:
            break;
    }
    
    _state = newState;
}

@end
