//
//  SFMusicPickerViewController.h
//  Streamify
//
//  Created by Le Minh Tu on 4/19/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"

@protocol SFMusicPickerViewControllerDelegate <NSObject>

- (void)songSelected:(SFSong *)song;

@end


@interface SFMusicPickerViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *topBackground;

- (id)initWithDelegate:(id)delegate;

@end
