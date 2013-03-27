//
//  SFUserProfileViewController.m
//  Streamify
//
//  Created by Le Viet Tien on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFUserProfileViewController.h"
#import <Parse/Parse.h>

@interface SFUserProfileViewController ()
@property (nonatomic, strong) NSDictionary *userProfile;
@end

@implementation SFUserProfileViewController

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
	// Do any additional setup after loading the view.
    
    if ([PFUser currentUser]) {
        self.userProfile = [PFUser currentUser][@"profile"];
    }
    
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSDictionary *userData = (NSDictionary *)result;
        
        NSString *facebookID = userData[@"id"];
        
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
        
        self.userProfile = @{@"facebookId": facebookID,
                             @"name": userData[@"name"],
                             @"location": userData[@"location"][@"name"],
                             @"gender": userData[@"gender"],
                             @"birthday": userData[@"birthday"],
                             @"relationship": userData[@"relationship_status"],
                             @"pictureURL": [pictureURL absoluteString]};
        
        [[PFUser currentUser] setObject:self.userProfile forKey:@"profile"];
        [[PFUser currentUser] saveInBackground];
        
        [self updateProfile];
    }];
}

- (void)updateProfile {
    self.nameField.text = self.userProfile[@"name"];
    self.genderField.text = self.userProfile[@"gender"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameField:nil];
    [self setGenderField:nil];
    [super viewDidUnload];
}
@end
