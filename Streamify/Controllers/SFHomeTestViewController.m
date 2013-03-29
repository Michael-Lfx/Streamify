//
//  SFUserProfileViewController.m
//  Streamify
//
//  Created by Le Viet Tien on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFHomeTestViewController.h"
#import "SFSocialManager.h"
#import <Parse/Parse.h>

@interface SFHomeTestViewController ()
@property (nonatomic, strong) NSDictionary *userProfile;
@end

@implementation SFHomeTestViewController

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
    
     NSArray *keys = [NSArray arrayWithObjects:@"follower", @"followee", nil];
     NSArray *values = [NSArray arrayWithObjects:@"tien", @"minh tu", nil];
     
     PFObject *testObject = [PFObject objectWithClassName:@"Follow" dictionary:[NSDictionary dictionaryWithObjects:values
     forKeys: keys]];
     [testObject saveInBackground];
    
    /*
     PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
     NSArray *dataArray = [query findObjects];
    
     NSEnumerator *e = [dataArray objectEnumerator];
     id object;
     while (object = [e nextObject]) {
        NSLog(@"%@", object);
     }
    NSLog([NSString stringWithFormat:@"%d", [query countObjects]]);
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile) name:@"updateMeSucceed" object:nil];
}

- (void)updateProfile {
    SFUser *me = [SFSocialManager sharedInstance].currentUser;
    self.nameField.text = me.name;
    NSLog(@"%@", me.facebookId);
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
