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
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?with=200&height=200", facebookID]];
            
            NSDictionary *userProfile = @{@"facebookId": facebookID,
                                          @"name": userData[@"name"],
                                          @"pictureURL": [pictureURL absoluteString]};
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] setObject:userData[@"name"] forKey:@"facebookName"];
            [[PFUser currentUser] setObject:[PFUser currentUser].objectId forKey:@"objectIdCopy"];
            [[PFUser currentUser] saveInBackground];
            
            self.currentUser = [[SFUser alloc] initWithPFUser:[PFUser currentUser]];
            [self sendCreateBroadcastRequest:self.currentUser.objectID withCallback:nil];
            
            self.following = [NSMutableArray array];
            self.liveChannels = [NSMutableArray array];
            
            [self getFollowingForUser:self.currentUser.objectID withCallback:^(id returnedObject) {
                NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:OPERATION_SUCCEEDED, kOperationResult, nil];
                response(resData);
            }];
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

- (void)sendCreateBroadcastRequest:(NSString *)channelID withCallback:(SFResponseBlock)response{
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               channelID, @"username",
                               nil];
    [self queryServerPath:@"/create.php" requestMethod:@"POST" parameters:queryDict withCallback:^(id returnedObject) {
        if (response) response(returnedObject);
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

- (void)getNumberOfFollwersForUser:(NSString *)userID withCallback:(SFResponseBlock)response {
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               userID, @"user_followed_object_id",
                               @"getAllFollowers", @"action",
                               nil];
    [self queryServerPath:@"/follow.php" requestMethod:@"POST" parameters:queryDict withCallback:^(id returnedObject) {
        if ([returnedObject[kOperationResult] isEqualToString:OPERATION_SUCCEEDED]) {
            id json = [returnedObject objectForKey:kResultJSON];
            int count = [[json objectForKey:@"followerCount"] intValue];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  OPERATION_SUCCEEDED, kOperationResult,
                                  [NSNumber numberWithInt:count], kResultNumberOfFollowers,
                                  nil];
            
            response((id)dict);
        } else {
            response(returnedObject);
        }
    }];
}

//- (void)follows:(NSString *)objectID withCallback:(SFResponseBlock)response{
//    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
//    [query whereKey:@"follower" equalTo:self.currentUser.objectID];
//    [query whereKey:@"following" equalTo:objectID];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (objects.count > 0) {
//            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     OPERATION_FAILED, kOperationResult,
//                                     @"You already followed this channel", kOperationError,
//                                     nil];
//            response((id)resData);
//        } else {
//            PFObject *relation = [PFObject objectWithClassName:@"Follow"];
//            [relation setObject:self.currentUser.objectID forKey:@"follower"];
//            [relation setObject:objectID forKey:@"following"];
//            [relation saveInBackground];
//
//            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     OPERATION_SUCCEEDED, kOperationResult,
//                                     nil];
//            response((id)resData);
//        }
//    }];
//}

- (void)follows:(NSString *)objectID withCallback:(SFResponseBlock)response {
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.currentUser.objectID, @"follower_object_id",
                               objectID, @"user_followed_object_id",
                               @"blank", @"follower_fb_id",
                               @"blank", @"user_followed_fb_id",
                               @"createFollow", @"action",
                               nil];
    [self queryServerPath:@"/follow.php" requestMethod:@"POST" parameters:queryDict withCallback:^(id returnedObject) {
        if ([[returnedObject objectForKey:kOperationResult] isEqualToString:OPERATION_SUCCEEDED]) {
            [self.following addObject:objectID];
        }
        response(returnedObject);
    }];
}

- (void)unfollows:(NSString *)objectID withCallback:(SFResponseBlock)response {
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.currentUser.objectID, @"follower_object_id",
                               objectID, @"user_followed_object_id",
                               @"blank", @"follower_fb_id",
                               @"blank", @"user_followed_fb_id",
                               @"deleteFollow", @"action",
                               nil];
    
    [self queryServerPath:@"/follow.php" requestMethod:@"POST" parameters:queryDict withCallback:^(id returnedObject) {
        if ([[returnedObject objectForKey:kOperationResult] isEqualToString:OPERATION_SUCCEEDED]) {
            NSString *idToRemoved;
            
            for (NSString *channelID in self.following) {
                if ([channelID isEqualToString:objectID]) {
                    idToRemoved = channelID;
                }
            }
            
            if (idToRemoved) {
                [self.following removeObject:idToRemoved];
            }
        }
        response(returnedObject);
    }];
}

//- (void)unfollows:(NSString *)objectID withCallback:(SFResponseBlock)response {
//    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
//    [query whereKey:@"follower" equalTo:self.currentUser.objectID];
//    [query whereKey:@"following" equalTo:objectID];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (objects.count == 0) {
//            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     OPERATION_FAILED, kOperationResult,
//                                     @"You have not followed this channel", kOperationError,
//                                     nil];
//            response((id)resData);
//        } else {
//            PFObject *relation = [objects objectAtIndex:0];
//            [relation deleteInBackground];
//
//            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     OPERATION_SUCCEEDED, kOperationResult,
//                                     nil];
//            response((id)resData);
//        }
//    }];
//}

//- (void)getFollowingForUser:(NSString *)userID withCallback:(SFResponseBlock)response {
//    [self fetchLiveChannelsWithCallback:^(id returnedObject) {
//        NSArray *onlineChannels = [returnedObject objectForKey:kResultLiveChannels];
//
//        PFQuery *followQuery = [PFQuery queryWithClassName:@"Follow"];
//        [followQuery whereKey:@"follower" equalTo:userID];
//
//        PFQuery *query = [PFUser query];
//        [query whereKey:@"objectId" matchesKey:@"following" inQuery:followQuery];
//
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            if (error) {
//                NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         OPERATION_FAILED, kOperationResult,
//                                         nil];
//                response((id)resData);
//            } else {
//                NSMutableArray *result = [NSMutableArray array];
//
//                for (PFUser *row in objects) {
//                    SFUser *user = [[SFUser alloc] initWithPFUser:row];
//                    user.followed = TRUE;
//                    if (onlineChannels) {
//                        for (SFUser *channel in onlineChannels) {
//                            if ([channel.objectID isEqualToString:user.objectID]) {
//                                user.isLive = YES;
//                            }
//                        }
//                    }
//                    [result addObject:user];
//                }
//                self.following = result;
//
//                NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
//                                         OPERATION_SUCCEEDED, kOperationResult,
//                                         result, kResultFollowing,
//                                         nil];
//
//                response((id)resData);
//            }
//        }];
//    }];
//}

- (void)getFollowingForUser:(NSString *)userID withCallback:(SFResponseBlock)response {
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.currentUser.objectID, @"follower_object_id",
                               @"getAllFollowingAndStatus", @"action",
                               nil];
    [self queryServerPath:@"/follow.php" requestMethod:@"POST" parameters:queryDict withCallback:^(id returnedObject) {
        if ([[returnedObject objectForKey:kOperationResult] isEqual:OPERATION_SUCCEEDED]) {
            NSMutableArray *followingArray = [NSMutableArray array];
            
            id json = [returnedObject objectForKey:kResultJSON];
            if (json != NULL) {
                for (id row in json) {
                    [followingArray addObject:row[@"user_followed_object_id"]];
                }
            }
            
            [self getUsersWithObjectIDs:followingArray withCallback:^(id returnedObject) {
                if ([[returnedObject objectForKey:kOperationResult] isEqual:OPERATION_SUCCEEDED]) {
                    NSMutableArray *result = [NSMutableArray array];
                    self.following = [NSMutableArray array];
                    
                    for (SFUser *user in [returnedObject objectForKey:kResultUsers]) {
                        for (id row in json) {
                            if ([(NSString *)row[@"user_followed_object_id"] isEqual:user.objectID]) {
                                user.isLive = [(NSString *)row[@"live"] isEqual:@"1"];
                            }
                        }
                        user.followed = YES;
                        [result addObject:user];
                        [self.following addObject:user.objectID];
                    }
                    
                    
                    NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                             OPERATION_SUCCEEDED, kOperationResult,
                                             result, kResultFollowing,
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
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.currentUser.objectID, @"users_object_id",
                               nil];
    [self queryServerPath:@"getLive.php" requestMethod:@"POST" parameters:queryDict withCallback:^(id returnedObject) {
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
                        
                        for (NSString *following in self.following) {
                            if ([following isEqualToString:user.objectID]) {
                                user.followed = YES;
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
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.currentUser.objectID, @"users_object_id",
                               nil];
    [self queryServerPath:@"getLive.php" requestMethod:@"POST" parameters:queryDict withCallback:^(id returnedObject) {
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
                        for (id row in json) {
                            if ([(NSString *)row[@"users_object_id"] isEqual:user.objectID]) {
                                user.followed = ([(NSNumber *)row[@"is_followed"] intValue] == 1);
                            }
                        }
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

- (void)searchChannelsForKeyword:(NSString *)keyword withCallback:(SFResponseBlock)response {
    NSString *regex = [NSString stringWithFormat:@".*%@.*", keyword];
    PFQuery *query = [PFUser query];
    [query whereKey:@"facebookName" matchesRegex:regex modifiers:@"i"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_FAILED, kOperationResult,
                                     nil];
            response((id)resData);
        } else {
            NSMutableArray *objectIDs = [NSMutableArray array];
            
            for (PFUser *row in objects) {
                [objectIDs addObject:row.objectId];
            }
            
            [self getUsersWithLiveStatusForObjectIDs:objectIDs withCallback:^(id returnedObject) {
                if ([returnedObject[kOperationResult] isEqualToString:OPERATION_SUCCEEDED]) {
                    for (SFUser *channel in returnedObject[kResultUsers]) {
                        [self checkFollowed:channel];
                    }
                    response(returnedObject);
                } else {
                    response(returnedObject);
                }
            }];
        }
    }];
}

- (void)checkFollowed:(SFUser *)channel {
    for (NSString *following in self.following) {
        if ([channel.objectID isEqualToString:following]) {
            channel.followed = YES;
        }
    }
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

- (void)getListenerCount:(NSString *)channelID withCallback:(SFResponseBlock)response{
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               channelID, @"users_object_id",
                               nil];
    [self queryServerPath:@"/getListenerCount.php" requestMethod:@"POST" parameters:queryDict withCallback:^(id returnedObject) {
        if ([returnedObject[kOperationResult] isEqualToString:OPERATION_SUCCEEDED]) {
            id json = [returnedObject objectForKey:kResultJSON];
            int count = [[json objectForKey:@"listener_count"] intValue];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  OPERATION_SUCCEEDED, kOperationResult,
                                  [NSNumber numberWithInt:count], kResultNumberofLsiteners,
                                  nil];
            response((id)dict);
        } else {
            response(returnedObject);
        }
    }];
}

-(void)changeListenerCountInServer:(NSString *)channelID changeAmount:(NSString *)changeAmount{
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               channelID, @"users_object_id",
                               changeAmount, @"change_amount",
                               nil];
    [self queryServerPath:@"/updateListenerCount.php" requestMethod:@"POST" parameters:queryDict withCallback:^(id returnedObject) {
    }];
}

-(void)publishGraphStory:(NSString *)broadcasterName{
    NSString *token = [[PFFacebookUtils session] accessToken];
    NSString *objectURL = @"http://rahij.com/ogstory.php?fb:app_id=444148202332879&og:type=music.radio_station&og:image=https://s-static.ak.fbcdn.net/images/devsite/attachment_blank.png";
    objectURL = [objectURL stringByAppendingString:[NSString stringWithFormat: @"&og:title=%@'s Channel", broadcasterName]];
                           
    NSLog(@"%@", objectURL);
    NSDictionary *queryDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               objectURL, @"radio_station",
                               token, @"access_token",
                               nil];
    [self queryServerPath:@"https://graph.facebook.com/me/streamifysg:stream" requestMethod:@"POST" parameters:queryDict withCallback:^(id returnedObject) {
            id json = [returnedObject objectForKey:kResultJSON];
            NSString *gid = [json objectForKey:@"id"];
        NSLog(@"%@", gid);
    }];
}

- (void)queryServerPath:(NSString*)apiSubPath
          requestMethod:(NSString *)reqMethod
             parameters:(NSDictionary*)parameters
           withCallback:(SFResponseBlock)responseCallback {
    
    NSURL *baseURL = [NSURL URLWithString:SERVER_ADDRESS];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    if ([apiSubPath hasPrefix:@"/"] == NO)
        apiSubPath = [NSString stringWithFormat:@"%@", apiSubPath];
    
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
                                             DLog(@"%@", error);
                                             DLog(@"%@", json);
                                             responseCallback((id)resData);
                                         }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    [queue addOperation:operation];
}

@end
