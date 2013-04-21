//
//  SFChatMessageCell.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFChatMessageCell.h"
#import "SFUIDefaultTheme.h"

@implementation SFChatMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImageView = [[UIImageView alloc] init];
        self.userNameLabel = [[UILabel alloc] init];
        self.messageLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.messageLabel];
     
    }
    return self;
}

- (void)styleCell {
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    
    /* cell background */
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.layer.borderColor = [[SFUIDefaultTheme mainTextColor] colorWithAlphaComponent:0.5].CGColor;
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    
    UIColor *colorOne = [UIColor colorWithWhite:0.1 alpha:0.0];
    UIColor *colorTwo = [UIColor colorWithWhite:0.0 alpha:0.1];
    UIColor *colorThree = [UIColor colorWithWhite:0.0 alpha:0.6];
    UIColor *colorFour = [UIColor colorWithWhite:0.0 alpha:1.0];
   
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.5];
    NSNumber *stopThree = [NSNumber numberWithFloat:0.55];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    layer.colors = colors;
    layer.locations = locations;
    
    layer.frame = self.contentView.bounds;
    [self.contentView.layer insertSublayer:layer atIndex:0];
    
    /* cell components */
    self.userNameLabel.backgroundColor = [UIColor clearColor];
    self.userNameLabel.textColor = [SFUIDefaultTheme mainTextColor];
    self.userNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = UILineBreakModeWordWrap;
}
	
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize stringSize = [self.messageLabel.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(kSFChatTableCellMessageFrameW, 9999) lineBreakMode:UILineBreakModeWordWrap];
    self.messageLabel.frame = CGRectMake(kSFChatTableCellMessageFrameX, kSFChatTableCellMessageFrameY, kSFChatTableCellMessageFrameW, stringSize.height);
    
    self.avatarImageView.frame = CGRectMake(kSFChatTableCellAvatarX, kSFChatTableCellAvatarY, kSFChatTableCellAvatarW, kSFChatTableCellAvatarH);
    self.userNameLabel.frame = CGRectMake(kSFChatTableCellUserNameFrameX, kSFChatTableCellUserNameFrameY, kSFChatTableCellUserNameFrameW, kSFChatTableCellUserNameFrameH);
    self.contentView.bounds = CGRectMake(0, 0, kSFChatTableCellFrameW,
                                         MAX(kSFChatTableCellFrameHDefault, kSFChatTableCellUserNameFrameY + kSFChatTableCellUserNameFrameH + self.messageLabel.height + 6));
    
    [self styleCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
