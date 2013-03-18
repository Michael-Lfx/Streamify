//
//  BaseViewController.m
//  AutoDealer
//
//  Created by Torin on 1/12/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import "BaseViewController.h"
#import "UIAlertView+Additions.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (UIViewController*)initWithNib
{
  NSString *className = NSStringFromClass([self class]);
  self = [self initWithNibName:className bundle:nil];
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self == nil)
    return self;
  
  self.title = NSStringFromClass([self class]);
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSString *className = NSStringFromClass([self class]);
  self.title = className;
  
  self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.view.autoresizesSubviews = YES;
  
  //Custom image view will stretch correctly on iPhone5
  /*
  UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general_background"]];
  backgroundImage.frame = self.view.bounds;
  backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  [self.view insertSubview:backgroundImage atIndex:0];
  */
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  DLog(@"Warning: Do not put any code in viewDidUnload. Deprecated since iOS 6.0");
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma mark - UI Helpers

- (UIViewController*)getViewControllerWithClassName:(NSString*)theClassName
{
  if ([theClassName length] <= 0)
    return nil;
  
  //Dynamically load the class
  Class theClass = NSClassFromString(theClassName);
  if (theClass == nil)
    return nil;
  
  NSObject* myViewController = [[theClass alloc] init];
  if (myViewController == nil)
    return nil;
  if ([myViewController isMemberOfClass:[UIViewController class]])
    return nil;
  
  return (UIViewController*)myViewController;
}


@end
