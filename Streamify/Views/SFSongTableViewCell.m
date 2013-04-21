//
//  SFPlaylistItemTableViewCell.m
//  Streamify
//
//  Created by Le Viet Tien on 19/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFSongTableViewCell.h"
#import "SFUIDefaultTheme.h"

@implementation SFSongTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.isStyled = false;
    }
    return self;
}

+ (NSString *)cellIdentifier {
    return @"PlaylistItemTableViewCellIdentifier";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self styleCell];
}

- (void)styleCell {
    if (!self.isStyled) {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = [[UIColor colorWithWhite:0.85 alpha:0.3] CGColor];
        
        /* cell background */
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brillant.png"]];
        self.contentView.layer.masksToBounds = YES;
        
        UIColor *colorOne = [UIColor colorWithWhite:1.0 alpha:0.5];
        UIColor *colorTwo = [UIColor colorWithWhite:0.9 alpha:0.5];
        
        NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
        
        NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
        NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
        
        NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
        
        CAGradientLayer *layer = [CAGradientLayer layer];
        
        layer.colors = colors;
        layer.locations = locations;
        
        layer.frame = self.contentView.bounds;
        [self.contentView.layer insertSublayer:layer atIndex:0];
        
        self.isStyled = true;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
