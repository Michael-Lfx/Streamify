//
//  SFUser.m
//  Streamify
//
//  Created by Le Viet Tien on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFUser.h"

@implementation SFUser

- (id)initWithPFUser:(PFUser *)user {
    if (self = [super initWithDictionary:[user objectForKey:@"profile"]]) {
        self.objectID = user.objectId;
        self.followed = NO;
        self.isLive = NO;
    }
    return self;
}

@end
