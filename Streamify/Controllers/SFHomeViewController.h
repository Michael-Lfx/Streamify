//
//  MainViewController.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"
#import "SFMetroCanvasViewController.h"
#import "SFSidebarViewController.h"

@interface SFHomeViewController : BaseViewController <MetroCanvasViewControllerProtocol>

@property (nonatomic, strong) SFMetroCanvasViewController *canvasViewController;
@property (nonatomic, strong) SFSidebarViewController *sidebarViewController;

@end
