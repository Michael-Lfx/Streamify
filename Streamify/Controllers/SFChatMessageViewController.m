//
//  SFChatMessageViewController.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFChatMessageViewController.h"

@interface SFChatMessageViewController ()
@property (nonatomic, weak) NSDictionary *messageData;
@property (nonatomic, weak) id<SFChatMessageViewControllerDelegate> delegate;
@end

@implementation SFChatMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithData:(NSDictionary *)data delegate:(id)delegate {
    self = [self initWithNib];
    self.delegate = delegate;
    self.messageData = data;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius = 3;
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brillant.png"]];
    
    [self applyGradientBackground];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAvatarImageView:nil];
    [self setUserNameLabel:nil];
    [self setMessageLabel:nil];
    [super viewDidUnload];
}

- (void)applyGradientBackground {
    
    UIColor *colorOne = [UIColor colorWithWhite:1.0 alpha:0.6];
    UIColor *colorTwo = [UIColor colorWithWhite:0.8 alpha:0.6];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    layer.colors = colors;
    layer.locations = locations;
    
    layer.frame = self.view.bounds;
    [self.view.layer insertSublayer:layer atIndex:1];
}

@end
