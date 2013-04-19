//
//  SFPlaylistItem.m
//  Streamify
//
//  Created by Le Viet Tien on 19/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFSong.h"

@implementation SFSong

- (id)initWithURL:(NSURL *)URL
            title:(NSString *)title
       artistName:(NSString *)artistName
        albumTitle:(NSString *)albumTitle
       albumCover:(UIImage *)albumCover
{
    self = [super init];
    if (self) {
        self.URL = URL;
        self.title = title;
        self.artistName = artistName;
        self.albumTitle = albumTitle;
        self.albumCover = albumCover;
    }
    return self;
}

@end
