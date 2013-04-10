//
//  SFLoginViewController.h
//  Streamify
//
//  Created by Le Viet Tien on 27/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"

@interface SFLoginViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@end
