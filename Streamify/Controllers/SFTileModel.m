//
//  TileModel.m
//  Metro
//
//  Created by Le Minh Tu on 3/27/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFTileModel.h"

@implementation SFTileModel

- (id)initWithName:(NSString *)title
          andCover:(UIImage *)cover
{
    self = [super init];
    if (self) {
        self.title = title;
        self.cover = cover;
    }
    return self;
}

- (id)initWithUser:(SFUser *)user {
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}

@end
