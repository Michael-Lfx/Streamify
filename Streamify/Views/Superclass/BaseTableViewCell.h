//
//  BaseTableViewCell.h
//  JanuaryApp
//
//  Created by Torin on 24/11/12.
//
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) UIViewController *parentVC;

+ (NSString*)cellIdentifier;

@end
