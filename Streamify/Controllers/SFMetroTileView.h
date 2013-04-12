//
//  MetroTileView.h
//  Metro2
//
//  Created by Le Minh Tu on 3/28/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFMetroTileView;

@interface SFMetroTileView : UIView

@property (strong, nonatomic) SFUser *user;

- (id)initWithUser:(SFUser *)user;

@end
