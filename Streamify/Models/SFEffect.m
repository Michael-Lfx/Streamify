//
//  SFEffect.m
//  Streamify
//
//  Created by Le Viet Tien on 23/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFEffect.h"

@implementation SFEffect

- (id)initWithName:(NSString *)effectName URL:(NSURL *)URL {
    if (self = [super init]) {
        self.effectName = effectName;
        self.URL = URL;
    }
    
    return self;
}

@end
