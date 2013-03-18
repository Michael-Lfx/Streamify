//
//  NSObject+Additions.m
//
//  Created by Jesper Särnesjö on 2010-05-29.
//  Copyright 2010 Cartomapic. All rights reserved.
//

#import "NSObject+Additions.h"

@implementation NSObject (Additions)

- (id)ifKindOfClass:(Class)c {
  return [self isKindOfClass:c] ? self : nil;
}

@end
