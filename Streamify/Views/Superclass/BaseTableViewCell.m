//
//  BaseTableViewCell.m
//  JanuaryApp
//
//  Created by Torin on 24/11/12.
//
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

+ (NSString*)cellIdentifier
{
  return @"sub_class_should_override_this";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self == nil)
    return self;
  
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}


#pragma mark - Convenient network actions




@end
