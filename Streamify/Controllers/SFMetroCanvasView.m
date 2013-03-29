//
//  SFMetroCanvasView.m
//  Streamify
//
//  Created by Le Minh Tu on 3/30/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFMetroCanvasView.h"

@implementation SFMetroCanvasView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        // CanvasView has only 1 subview which is the ScrollView;
        return [[self subviews] lastObject];
    }
    return view;
}

@end
