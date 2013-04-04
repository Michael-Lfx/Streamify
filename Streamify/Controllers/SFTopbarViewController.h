//
//  SFTopbarViewController.h
//  Streamify
//
//  Created by Le Minh Tu on 4/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"

@protocol SFTopbarViewControllerProtocol <NSObject>


@end

@interface SFTopbarViewController : BaseViewController

- (id)initTopbarWithDelegate:(id)delegate;

@end
