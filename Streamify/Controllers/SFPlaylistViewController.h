//
//  SFPlaylistViewController.h
//  Streamify
//
//  Created by Le Viet Tien on 19/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"

@interface SFPlaylistViewController : BaseViewController

- (id)initWithSelectable:(BOOL)selectable editable:(BOOL)editable;
- (void)addSong:(SFSong *)song;
- (void)selectNextRow;
- (void)selectPreviousRow;
- (void)selectRow:(NSInteger)row;

@end
