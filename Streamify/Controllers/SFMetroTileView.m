//
//  MetroTileView.m
//  Metro2
//
//  Created by Le Minh Tu on 3/28/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFMetroTileView.h"

@implementation SFMetroTileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    NSString *formattedTitle = [NSString stringWithFormat:@"\t\t\t%@", title];
    self.titleView.text = formattedTitle;
}

- (void)setCover:(UIImage *)cover
{
    self.coverView.image = cover;
}

- (void)setPictureLink:(NSString *)link {
    [self.coverView setImageWithURL:[NSURL URLWithString:link] placeholderImage:nil];
}

@end
