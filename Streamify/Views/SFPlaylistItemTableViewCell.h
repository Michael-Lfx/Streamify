//
//  SFPlaylistItemTableViewCell.h
//  Streamify
//
//  Created by Le Viet Tien on 19/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFPlaylistItemTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@end
