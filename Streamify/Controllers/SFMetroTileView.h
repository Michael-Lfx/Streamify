//
//  MetroTileView.h
//  Metro2
//
//  Created by Le Minh Tu on 3/28/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MetroTileView;

@protocol MetroTileActionDelegate <NSObject>

- (void)tapOnTile:(UITapGestureRecognizer *)tapRecognizer;

@end

@interface MetroTileView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *coverView;
@property (strong, nonatomic) IBOutlet UILabel *titleView;

- (void)setTitle:(NSString *)title;
- (void)setCover:(UIImage *)cover;


@end
