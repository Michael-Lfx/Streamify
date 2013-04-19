//
//  SFSlider.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 19/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFSlider.h"

@implementation SFSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -10, -10);
    return CGRectContainsPoint(bounds, point);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
