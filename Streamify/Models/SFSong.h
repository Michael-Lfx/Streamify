//
//  SFPlaylistItem.h
//  Streamify
//
//  Created by Le Viet Tien on 19/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseModel.h"

@interface SFSong : BaseModel

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *albumTitle;
@property (nonatomic, strong) UIImage *albumCover;

- (id)initWithURL:(NSURL *)URL
            title:(NSString *)title
       artistName:(NSString *)artistName
        albumTitle:(NSString *)albumTitle
       albumCover:(UIImage *)albumCover;

@end
