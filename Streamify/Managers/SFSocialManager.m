//
//  SFSocialManager.m
//  Streamify
//
//  Created by Le Viet Tien on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFSocialManager.h"

@interface SFSocialManager ()
@property (nonatomic, strong) NSTimer *timer;
@end

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
        
//        [self follows:@"TESTUSER"];
    }];
    
    self.timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(updateLiveChannels) userInfo:nil repeats:YES];
    
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

    return result;
}

- (BOOL)follows:(NSString *)objectID {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"follower" equalTo:self.currentUser.objectID];
    [query whereKey:@"following" equalTo:objectID];
    NSArray *dataArray = [query findObjects];
    if (dataArray.count > 0) return FALSE;
    
    PFObject *relation = [PFObject objectWithClassName:@"Follow"];
    [relation setObject:self.currentUser.objectID forKey:@"follower"];
    [relation setObject:objectID forKey:@"following"];
    [relation saveInBackground];
    return YES;
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

- (void)updateLiveChannels {
    NSMutableArray *result = [NSMutableArray array];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Broadcast"];
    [query whereKey:@"live" equalTo:@"1"];
    NSArray *dataArray = [query findObjects];
    
    for (id row in dataArray) {
        NSString *objectID = [row objectForKey:@"users_object_id"];
        [result addObject:[self getUser:objectID]];
    }
    
    self.liveChannels = [NSArray arrayWithArray:result];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLiveChannelsSuccessNotification object:self userInfo:nil];
}

@end
