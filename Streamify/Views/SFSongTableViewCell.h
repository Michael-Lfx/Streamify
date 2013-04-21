//
//  SFPlaylistItemTableViewCell.h
//  Streamify
//
//  Created by Le Viet Tien on 19/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSFSongTableViewCellRowHeight (80)

@interface SFSongTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumCoverView;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;

@property (nonatomic) BOOL isStyled;

@end
