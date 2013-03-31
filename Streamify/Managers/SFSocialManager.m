//
//  SFSocialManager.m
//  Streamify
//
//  Created by Le Viet Tien on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFSocialManager.h"

@implementation SFSocialManager

+ (SFSocialManager *)sharedInstance
{
    static SFSocialManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (BOOL)updateMe {
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSDictionary *userData = (NSDictionary *)result;
        
        NSString *facebookID = userData[@"id"];
        NSLog(@"%@", facebookID);
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
        
        NSDictionary *userProfile = @{@"facebookId": facebookID,
                                      @"name": userData[@"name"],
                                      @"pictureURL": [pictureURL absoluteString]};
        
        [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
        [[PFUser currentUser] saveInBackground];
        
        self.currentUser = [[SFUser alloc] initWithPFUser:[PFUser currentUser]];
        self.currentUser.followings = [self getFollowingForUser:self.currentUser.objectID];
        self.currentUser.followers = [self getFollowersForUser:self.currentUser.objectID];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMeSuccessNotification object:self userInfo:nil];
    }];
    
    return  YES;
}

- (NSArray *)getFollowersForUser:(NSString *)objectID {
    NSMutableArray *result = [NSMutableArray array];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"following" equalTo:self.currentUser.objectID];
    
    NSArray *dataArray = [query findObjects];
    for (id row in dataArray) {
        NSString *objectID = [row objectForKey:@"follower"];
        [result addObject:[self getUser:objectID]];
    }
    
//    NSLog(@"Number of followers: %lu", (unsigned long)result.count);
    return result;
}

- (SFUser *)getUser:(NSString *)objectID {
    PFUser *user = [PFQuery getUserObjectWithId:objectID];
    return [[SFUser alloc] initWithPFUser:user];
}

- (NSArray *)getFollowingForUser:(NSString *)objectID {
    NSMutableArray *result = [NSMutableArray array];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"follower" equalTo:self.currentUser.objectID];
    
    NSArray *dataArray = [query findObjects];
    for (id row in dataArray) {
        NSString *objectID = [row objectForKey:@"following"];
        [result addObject:[self getUser:objectID]];
    }
    
//    NSLog(@"Number of followings: %lu", (unsigned long)result.count);
    return result;
}

@end
