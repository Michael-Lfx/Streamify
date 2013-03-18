//
//  BaseViewController.h
//  AutoDealer
//
//  Created by Torin on 1/12/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (UIViewController*)initWithNib;

/*
 * Obtain a class instance object from a string class name
 */
- (UIViewController*)getViewControllerWithClassName:(NSString*)theClassName;

@end
