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
        
        [self styleCell];
    }
    return self;
}

- (void)styleCell {
    /* cell background */
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.layer.borderColor = [[SFUIDefaultTheme mainTextColor] colorWithAlphaComponent:0.7].CGColor;
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.cornerRadius = 7;
    self.contentView.layer.masksToBounds = YES;
    
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
    
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    
    CGSize stringSize = [self.messageLabel.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15] constrainedToSize:CGSizeMake(kSFChatTableCellMessageFrameW, 9999) lineBreakMode:UILineBreakModeWordWrap];
    self.messageLabel.frame = CGRectMake(kSFChatTableCellMessageFrameX, kSFChatTableCellMessageFrameY, kSFChatTableCellMessageFrameW, stringSize.height);
    
    self.avatarImageView.frame = CGRectMake(kSFChatTableCellAvatarX, kSFChatTableCellAvatarY, kSFChatTableCellAvatarW, kSFChatTableCellAvatarH);
    self.userNameLabel.frame = CGRectMake(kSFChatTableCellUserNameFrameX, kSFChatTableCellUserNameFrameY, kSFChatTableCellUserNameFrameW, kSFChatTableCellUserNameFrameH);
    self.contentView.bounds = CGRectMake(0, 0, kSFChatTableCellFrameW,
                                         MAX(kSFChatTableCellFrameHDefault, kSFChatTableCellUserNameFrameY + kSFChatTableCellUserNameFrameH + self.messageLabel.height + 6));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
