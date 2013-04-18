//
//  SFSocialManager.m
//  Streamify
//
//  Created by Le Viet Tien on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFSocialManager.h"

@interface SFSocialManager ()
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

- (void)updateMeWithCallback:(SFResponseBlock)response {
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
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
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:OPERATION_SUCCEEDED, kOperationResult, nil];
            response(resData);
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                      isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [PFUser logOut];
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:OPERATION_FAILED, kOperationResult, nil];
            response(resData);
        } else {
            NSLog(@"Some other error: %@", error);
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:OPERATION_FAILED, kOperationResult, nil];
            response(resData);
        }

    }];
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
            
            for (PFUser *row in objects) {
                [result addObject:[[SFUser alloc] initWithPFUser:row]];
            }
            
            self.allUsers = result;
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
                                     result, kResultAllUsers,
                                     nil];
            response((id)resData);
        }
    }];
}

- (void)getFollowersForUser:(NSString *)userID withCallback:(SFResponseBlock)response {
    PFQuery *followQuery = [PFQuery queryWithClassName:@"Follow"];
    [followQuery whereKey:@"following" equalTo:userID];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" matchesKey:@"follower" inQuery:followQuery];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_FAILED, kOperationResult,
                                     nil];
            response((id)resData);
        } else {
            NSMutableArray *result = [NSMutableArray array];
            
            for (PFUser *row in objects) {
                [result addObject:[[SFUser alloc] initWithPFUser:row]];
            }
            
            self.followers = result;
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
                                     result, kResultFollowers,
                                     nil];
            
            response((id)resData);
        }
    }];
}

- (void)follows:(NSString *)objectID withCallback:(SFResponseBlock)response{
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"follower" equalTo:self.currentUser.objectID];
    [query whereKey:@"following" equalTo:objectID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_FAILED, kOperationResult,
                                     @"You already followed this channel", kOperationError,
                                     nil];
            response((id)resData);
        } else {
            PFObject *relation = [PFObject objectWithClassName:@"Follow"];
            [relation setObject:self.currentUser.objectID forKey:@"follower"];
            [relation setObject:objectID forKey:@"following"];
            [relation saveInBackground];
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
                                     nil];
            response((id)resData);
        }
    }];
}

- (void)unfollows:(NSString *)objectID withCallback:(SFResponseBlock)response {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"follower" equalTo:self.currentUser.objectID];
    [query whereKey:@"following" equalTo:objectID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count == 0) {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_FAILED, kOperationResult,
                                     @"You have not followed this channel", kOperationError,
                                     nil];
            response((id)resData);
        } else {
            PFObject *relation = [objects objectAtIndex:0];
            [relation deleteInBackground];
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
                                     nil];
            response((id)resData);
        }
    }];
}

//- (void)getFollowingForUser:(NSString *)userID withCallback:(SFResponseBlock)response {
//    PFQuery *followQuery = [PFQuery queryWithClassName:@"Follow"];
//    [followQuery whereKey:@"follower" equalTo:userID];
//
//    PFQuery *query = [PFUser query];
//    [query whereKey:@"objectId" matchesKey:@"following" inQuery:followQuery];
//
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (error) {
//            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     OPERATION_FAILED, kOperationResult,
//                                     nil];
//            response((id)resData);
//        } else {
//            NSMutableArray *result = [NSMutableArray array];
//
//            for (PFUser *row in objects) {
//                SFUser *user = [[SFUser alloc] initWithPFUser:row];
//                user.followed = TRUE;
//                [result addObject:user];
//            }
//            self.following = result;
//
//            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     OPERATION_SUCCEEDED, kOperationResult,
//                                     result, kResultFollowing,
//                                     nil];
//
//            response((id)resData);
//        }
//    }];
//}

- (void)getFollowingForUser:(NSString *)userID withCallback:(SFResponseBlock)response {
    [self fetchLiveChannelsWithCallback:^(id returnedObject) {
        NSArray *onlineChannels = [returnedObject objectForKey:kResultLiveChannels];
        
        PFQuery *followQuery = [PFQuery queryWithClassName:@"Follow"];
        [followQuery whereKey:@"follower" equalTo:userID];
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectId" matchesKey:@"following" inQuery:followQuery];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                         OPERATION_FAILED, kOperationResult,
                                         nil];
                response((id)resData);
            } else {
                NSMutableArray *result = [NSMutableArray array];
                
                for (PFUser *row in objects) {
                    SFUser *user = [[SFUser alloc] initWithPFUser:row];
                    user.followed = TRUE;
                    if (onlineChannels) {
                        for (SFUser *channel in onlineChannels) {
                            if ([channel.objectID isEqualToString:user.objectID]) {
                                user.isLive = YES;
                            }
                        }
                    }
                    [result addObject:user];
                }
                self.following = result;
                
                NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                         OPERATION_SUCCEEDED, kOperationResult,
                                         result, kResultFollowing,
                                         nil];
                
                response((id)resData);
            }
        }];
    }];
}

- (void)getUsersWithObjectIDs:(NSArray *)objectIDs withCallback:(SFResponseBlock)response{
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" containedIn:objectIDs];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_FAILED, kOperationResult,
                                     nil];
            response((id)resData);
        } else {
            NSMutableArray *result = [NSMutableArray array];
            
            for (PFUser *row in objects) {
                SFUser *user = [[SFUser alloc] initWithPFUser:row];
                [result addObject:user];
            }
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
                                     result, kResultUsers,
                                     nil];
            
            response((id)resData);
        }
    }];
}

- (void)getUsersWithLiveStatusForObjectIDs:(NSArray *)objectIDs withCallback:(SFResponseBlock)response {
    [self queryServerPath:@"getLive.php" requestMethod:@"GET" parameters:nil withCallback:^(id returnedObject) {
        if ([[returnedObject objectForKey:kOperationResult] isEqual:OPERATION_SUCCEEDED]) {
            NSMutableArray *liveChannelNames = [NSMutableArray array];
            
            id json = [returnedObject objectForKey:kResultJSON];
            if (json != NULL) {
                for (id row in json) {
                    [liveChannelNames addObject:[row objectForKey:@"users_object_id"]];
                }
            }
            
            [self getUsersWithObjectIDs:objectIDs withCallback:^(id returnedObject) {
                if ([[returnedObject objectForKey:kOperationResult] isEqual:OPERATION_SUCCEEDED]) {
                    NSMutableArray *result = [NSMutableArray array];
                    
                    for (SFUser *user in [returnedObject objectForKey:kResultUsers]) {
                        for (NSString *liveChannelName in liveChannelNames) {
                            if ([liveChannelName isEqualToString:user.objectID]) {
                                user.isLive = YES;
                            }
                        }
                        [result addObject:user];
                    }
                    
                    NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                             OPERATION_SUCCEEDED, kOperationResult,
                                             result, kResultUsers,
                                             nil];
                    response((id)resData);
                } else {
                    response(returnedObject);
                }

            }];
        } else {
            response(returnedObject);
        }
    }];
}

- (void)fetchLiveChannelsWithCallback:(SFResponseBlock)response {
    [self queryServerPath:@"getLive.php" requestMethod:@"GET" parameters:nil withCallback:^(id returnedObject) {
        if ([[returnedObject objectForKey:kOperationResult] isEqual:OPERATION_SUCCEEDED]) {
            NSMutableArray *liveChannelNames = [NSMutableArray array];
            
            id json = [returnedObject objectForKey:kResultJSON];
            if (json != NULL) {
                for (id row in json) {
                    [liveChannelNames addObject:[row objectForKey:@"users_object_id"]];
                }
            }
            
            [self getUsersWithObjectIDs:liveChannelNames withCallback:^(id returnedObject) {
                if ([[returnedObject objectForKey:kOperationResult] isEqual:OPERATION_SUCCEEDED]) {
                    NSMutableArray *result = [NSMutableArray array];
                    
                    for (SFUser *user in [returnedObject objectForKey:kResultUsers]) {
                        user.isLive = YES;
                        [result addObject:user];
                    }
                    
                    NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                             OPERATION_SUCCEEDED, kOperationResult,
                                             result, kResultLiveChannels,
                                             nil];
                    response((id)resData);
                } else {
                    response(returnedObject);
                }
            }];
        } else {
            response(returnedObject);
        }
    }];
}

- (void)postMessage:(NSDictionary *)dict withCallback:(SFResponseBlock)response {
    NSString *channel = [dict objectForKey:kMessageChannel];
    NSString *text = [dict objectForKey:kMessageText];
    NSString *name = [dict objectForKey:kMessageName];
    NSString *pictureURL = [dict objectForKey:kMessagePictureURL];
    //    NSDate *time = [dict objectForKey:kMessageTime];
    
    PFObject *newMessage = [PFObject objectWithClassName:@"Comment"];
    [newMessage setObject:channel forKey:kMessageChannel];
    [newMessage setObject:text forKey:kMessageText];
    [newMessage setObject:name forKey:kMessageName];
    [newMessage setObject:pictureURL forKey:kMessagePictureURL];
    //    [newMessage setObject:time forKey:kMessageTime];
    
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
                                     dict, kResultMessage,
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
    [self fetchChannelMessages:channelID lastUpdated:updateTime limit:20 withCallback:response];
}

- (void)fetchChannelMessages:(NSString *)channelID
                 lastUpdated:(NSDate *)updateTime
                       limit:(NSInteger)limit
                withCallback:(SFResponseBlock)response {
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:kMessageChannel equalTo:channelID];
    //[query whereKey:kMessageTime greaterThan:updateTime];
    [query addDescendingOrder:kMessageTime];
    query.limit = limit;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *result = [NSMutableArray array];
            
            for (PFObject *row in objects) {
                [result addObject:[[SFMessage alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [row objectForKey:kMessageChannel], kMessageChannel,
                                                                         [row objectForKey:kMessageName], kMessageName,
                                                                         [row objectForKey:kMessageText], kMessageText,
                                                                         [row objectForKey:kMessagePictureURL], kMessagePictureURL,
                                                                         row.createdAt, kMessageTime,
                                                                         nil]]];
            }
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
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

- (void)queryServerPath:(NSString*)apiSubPath
          requestMethod:(NSString *)reqMethod
             parameters:(NSDictionary*)parameters
           withCallback:(SFResponseBlock)responseCallback {
    
    NSURL *baseURL = [NSURL URLWithString:SERVER_ADDRESS];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    if ([apiSubPath hasPrefix:@"/"] == NO)
        apiSubPath = [NSString stringWithFormat:@"/%@", apiSubPath];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:reqMethod path:apiSubPath parameters:parameters];
    
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
