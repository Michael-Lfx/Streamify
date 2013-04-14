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

@interface SFMetroRefreshHeaderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic) SFMetroPullRefreshState state;

@end
