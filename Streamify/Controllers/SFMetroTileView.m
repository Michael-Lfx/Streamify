//
//  MetroTileView.m
//  Metro2
//
//  Created by Le Minh Tu on 3/28/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFMetroConstants.h"
#import "SFMetroTileView.h"

#define kMetroTileFormatString @"\t\t\t%@"
#define kMetroTileCoverImagePlaceHolder @"placeholder.png"

@interface SFMetroTileView ()

@property (strong, nonatomic) IBOutlet UIImageView *coverView;
@property (strong, nonatomic) IBOutlet UILabel *titleView;

@end


@implementation SFMetroTileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    self = [[[NSBundle mainBundle] loadNibNamed:kMetroTileViewNibName owner:self options:nil] lastObject];
    return self;
}

- (void)setUser:(SFUser *)user {
    _user = user;
    NSString *title = [NSString stringWithFormat:@"%@ %@", user.name, user.objectID];
    NSString *formattedTitle = [NSString stringWithFormat:kMetroTileFormatString, title];
    self.titleView.text = formattedTitle;
    
    [self.coverView setImageWithURL:[NSURL URLWithString:user.pictureURL] placeholderImage:nil];
}

- (id)initWithUser:(SFUser *)user
{
    self = [[[NSBundle mainBundle] loadNibNamed:kMetroTileViewNibName owner:self options:nil] lastObject];
    if (self) {
        self.user = user;
        
        NSString *title = [NSString stringWithFormat:@"%@ %@", user.name, user.objectID];
        NSString *formattedTitle = [NSString stringWithFormat:kMetroTileFormatString, title];
        self.titleView.text = formattedTitle;
        
        [self.coverView setImageWithURL:[NSURL URLWithString:user.pictureURL]
                       placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    return self;
}

@end
