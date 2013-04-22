//
//  SFSettingsViewController.h
//  Streamify
//
//  Created by Rahij Ramsharan on 4/21/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SFSettingsViewController : BaseViewController{
    UITextField *effectName;
}
@property (nonatomic) BOOL isRecording;
@property (nonatomic, retain) IBOutlet UITextField *effectName;
- (IBAction)recordPressed:(id)sender;
- (IBAction)stopPressed:(id)sender;
- (IBAction)playPressed:(id)sender;
@end
