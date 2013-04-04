//
//  SFTopbarViewController.m
//  Streamify
//
//  Created by Le Minh Tu on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFTopbarViewController.h"

@interface SFTopbarViewController ()

@property (nonatomic, weak) id<SFTopbarViewControllerProtocol> delegate;

@end

@implementation SFTopbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initTopbarWithDelegate:(id)delegate
{
    self = [self initWithNib];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
