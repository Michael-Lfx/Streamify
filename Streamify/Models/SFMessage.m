//
//  SFMessage.m
//  Streamify
//
//  Created by Le Viet Tien on 12/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFMessage.h"

@implementation SFMessage

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.timeCreated = [dict objectForKey:kMessageTime];
    }
    return self;
}

@end
