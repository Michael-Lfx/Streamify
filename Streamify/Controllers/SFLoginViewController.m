//
//  SFLoginViewController.m
//  Streamify
//
//  Created by Le Viet Tien on 27/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFLoginViewController.h"
#import <Parse/Parse.h>
#import "SFSocialManager.h"
#import "SFHomeViewController.h"

@interface SFLoginViewController ()

@end

@implementation SFLoginViewController

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
    
    self.loginButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.loginButton.layer.shadowOpacity = 0.3f;
    self.loginButton.layer.shadowRadius = 3.0f;
    self.loginButton.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.loginButton.layer.masksToBounds = NO;
}

- (IBAction)loginButtonPressed:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[@"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [[SFSocialManager sharedInstance] updateMeWithCallback:^(id returnedObject) {
                if ([[returnedObject objectForKey:kOperationResult] isEqual:OPERATION_SUCCEEDED]) {
                    SFHomeViewController *homeViewController = [[SFHomeViewController alloc] init];
                    [self.navigationController pushViewController:homeViewController animated:YES];
                } else {
                    NSLog(@"Uh oh. An error occurred");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                    [alert show];
                }
            }];
        } else {
            NSLog(@"User with facebook logged in!");
            [[SFSocialManager sharedInstance] updateMeWithCallback:^(id returnedObject) {
                if ([[returnedObject objectForKey:kOperationResult] isEqual:OPERATION_SUCCEEDED]) {
                    SFHomeViewController *homeViewController = [[SFHomeViewController alloc] init];
                    [self.navigationController pushViewController:homeViewController animated:YES];
                } else {
                    NSLog(@"Uh oh. An error occurred");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                    [alert show];
                }
            }];
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLoginButton:nil];
    [super viewDidUnload];
}

@end
