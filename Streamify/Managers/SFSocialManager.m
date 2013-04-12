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
        [[PFUser currentUser] setObject:[PFUser currentUser].objectId forKey:@"objectIdCopy"];
        [[PFUser currentUser] saveInBackground];
        
        self.currentUser = [[SFUser alloc] initWithPFUser:[PFUser currentUser]];
        //self.currentUser.followings = [self getFollowingForUser:self.currentUser.objectID];
        self.currentUser.followings = [self getAllUsers];
        self.currentUser.followers = [self getFollowersForUser:self.currentUser.objectID];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMeSuccessNotification object:self userInfo:nil];
        
//        [self follows:@"TESTUSER"];
    }];
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateLiveChannels) userInfo:nil repeats:YES];
//    [self.timer fire];
    [self updateLiveChannels];
    
    return  YES;
}

- (NSArray *)getAllUsers{
    NSMutableArray *result = [NSMutableArray array];
    PFQuery *query = [PFUser query];
    NSArray *dataArray = [query findObjects];
    for (PFObject *row in dataArray) {
        NSString *objectID = [row objectForKey:@"objectIdCopy"];
        [result addObject:[self getUser:objectID]];
    }
    return result;
}

- (void)getAllUsersWithCallback:(SFResponseBlock)response {
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_FAILED, kOperationResult,
                                     nil];
            response((id)resData);
        } else {
            NSMutableArray *result = [NSMutableArray array];
            
            for (id row in objects) {
                NSString *userID = [row objectForKey:@"objectIdCopy"];
                [result addObject:[self getUser:userID]];
            }
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
                                     result, kResultAllUsers,
                                     nil];
            response((id)resData);
        }
    }];
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

- (void)getFollowersForUser:(NSString *)userID withCallback:(SFResponseBlock)response {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"following" equalTo:userID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_FAILED, kOperationResult,
                                     nil];
            response((id)resData);
        } else {
            NSMutableArray *result = [NSMutableArray array];
            
            for (id row in objects) {
                NSString *objectID = [row objectForKey:@"follower"];
                [result addObject:[self getUser:objectID]];
            }
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
                                     result, kResultFollowers,
                                     nil];
            
            response((id)resData);
        }
    }];
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

- (void)getFollowingForUser:(NSString *)userID withCallback:(SFResponseBlock)response {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"follower" equalTo:userID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_FAILED, kOperationResult,
                                     nil];
            response((id)resData);
        } else {
            NSMutableArray *result = [NSMutableArray array];
            
            for (id row in objects) {
                NSString *objectID = [row objectForKey:@"following"];
                [result addObject:[self getUser:objectID]];
            }
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
                                     result, kResultFollowing,
                                     nil];
            
            response((id)resData);
        }
    }];
}

- (void)updateLiveChannels {
    NSMutableArray *result = [NSMutableArray array];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Broadcast"];
    [query whereKey:@"live" equalTo:[NSNumber numberWithInt:1]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (id row in objects) {
            NSString *objectID = [row objectForKey:@"users_object_id"];
            [result addObject:[self getUser:objectID]];
        }
        
        self.liveChannels = [NSArray arrayWithArray:result];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateLiveChannelsSuccessNotification object:self userInfo:nil];
        NSLog(@"Number of live channels = %d", self.liveChannels.count);
    }];
}

- (void)updateLiveChannelsWithCallback:(SFResponseBlock)response {
    NSMutableArray *result = [NSMutableArray array];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Broadcast"];
    [query whereKey:@"live" equalTo:[NSNumber numberWithInt:1]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_FAILED, kOperationResult,
                                     nil];
            response((id)resData);
        } else {
            for (id row in objects) {
                NSString *objectID = [row objectForKey:@"users_object_id"];
                [result addObject:[self getUser:objectID]];
            }
            
            self.liveChannels = [NSArray arrayWithArray:result];
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
                                     self.liveChannels, kResultLiveChannels,
                                     nil];
            
            response((id)resData);
        }
    }];

}

- (void)fetchLiveChannelsWithCallback:(SFResponseBlock)response {
    [self getQueryServerPath:@"/getLive.php"
                  parameters:nil
                withCallback:response];
}

- (void)postMessage:(NSDictionary *)dict withCallback:(SFResponseBlock)response {
    NSString *channel = [dict objectForKey:kMessageChannel];
    NSString *text = [dict objectForKey:kMessageText];
    NSString *userID = [dict objectForKey:kMessageUser];
    
    PFObject *newMessage = [PFObject objectWithClassName:@"Comment"];
    [newMessage setObject:channel forKey:kMessageChannel];
    [newMessage setObject:text forKey:kMessageText];
    [newMessage setObject:userID forKey:kMessageUser];
    
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
                                     nil];
            response((id)resData);
        } else {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_FAILED, kOperationResult,
                                     nil];
            response((id)resData);
        }
    }];
}


- (void)fetchChannelMessages:(NSString *)channelID
                 lastUpdated:(NSDate *)updateTime
                withCallback:(SFResponseBlock)response {
    [self fetchChannelMessages:channelID lastUpdated:updateTime limit:1000 withCallback:response];
}

- (void)fetchChannelMessages:(NSString *)channelID
                 lastUpdated:(NSDate *)updateTime
                       limit:(NSInteger)limit
                withCallback:(SFResponseBlock)response {
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:kMessageChannel equalTo:channelID];
    [query whereKey:@"createdAt" greaterThan:updateTime];
    [query addDescendingOrder:@"createdAt"];
    query.limit = limit;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *result = [NSMutableArray array];
            
            for (id row in objects) {
                [result addObject:[[SFMessage alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [row objectForKey:kMessageChannel], kMessageChannel,
                                                                         [row objectForKey:kMessageUser], kMessageUser,
                                                                         [row objectForKey:kMessageText], kMessageText,
                                                                         nil]]];
            }
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_FAILED, kOperationResult,
                                     result, kResultNewMessages,
                                     nil];
            response((id)resData);
        } else {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_FAILED, kOperationResult,
                                     nil];
            response((id)resData);
        }
    }];
}

- (void)getQueryServerPath:(NSString*)apiSubPath
                 parameters:(NSDictionary*)parameters
               withCallback:(SFResponseBlock)responseCallback {
    
    NSURL *baseURL = [NSURL URLWithString:SERVER_ADDRESS];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    if ([apiSubPath hasPrefix:@"/"] == NO)
        apiSubPath = [NSString stringWithFormat:@"/%@", apiSubPath];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:apiSubPath parameters:parameters];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json)
                                         {
                                             [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                             NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      OPERATION_SUCCEEDED, kOperationResult,
                                                                      json, kResultJSON,
                                                                      nil];
                                             responseCallback((id)resData);
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSString *json) {
                                             [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                             NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      OPERATION_FAILED, kOperationResult,
                                                                      nil];
                                             responseCallback((id)resData);
                                         }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    [queue addOperation:operation];
}

- (void)postQueryServerPath:(NSString*)apiSubPath
             parameters:(NSDictionary*)parameters
           withCallback:(SFResponseBlock)responseCallback {
    
    NSURL *baseURL = [NSURL URLWithString:SERVER_ADDRESS];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    if ([apiSubPath hasPrefix:@"/"] == NO)
        apiSubPath = [NSString stringWithFormat:@"/%@", apiSubPath];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:apiSubPath parameters:parameters];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json)
                                         {
                                             [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                             NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                     OPERATION_SUCCEEDED, kOperationResult,
                                                                     json, kResultJSON,
                                                                     nil];
                                             responseCallback((id)resData);
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSString *json) {
                                             [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
                                             NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      OPERATION_FAILED, kOperationResult,
                                                                      nil];
                                            responseCallback((id)resData);
                                         }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    [queue addOperation:operation];
}

@end
