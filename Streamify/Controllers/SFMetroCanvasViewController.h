//
//  MetroViewController.h
//  Metro2
//
//  Created by Le Minh Tu on 3/28/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetroCanvasViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *tiles;
@property (nonatomic, strong) UIViewController *p;

@end
