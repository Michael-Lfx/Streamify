//
//  SFMetroCanvasViewController.h
//  Streamify
//
//  Created by Le Minh Tu on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"

@interface SFMetroCanvasViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *tiles;

@end
