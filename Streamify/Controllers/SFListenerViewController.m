//
//  SFListenerViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFConstants.h"
#import "SFListenerViewController.h"

@interface SFListenerViewController ()

@end

@implementation SFListenerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Testing
    self.mainColumnViewController = [[SFMainColumnViewController alloc] init];
    self.mainColumnViewController.view.frame = CGRectMake(kMainColumnFrameX,
                                                          kMainColumnFrameY,
                                                          kMainColumnFrameW,
                                                          kMainColumnFrameH);
    [self.view addSubview:self.mainColumnViewController.view];
    
    // Sidebar must be added after main column for shadow
    self.sidebarViewController = [[SFSidebarViewController alloc] initWithNib];;
    [self.view addSubview:self.sidebarViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
