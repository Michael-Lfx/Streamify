//
//  BaseNavigationController.m
//  AutoDealer
//
//  Created by Torin on 1/12/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

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
  
  return self;
}

@end
