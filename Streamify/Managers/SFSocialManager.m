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


- (void)getFollowingForUser:(NSString *)userID withCallback:(SFResponseBlock)response {
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
                [result addObject:[[SFUser alloc] initWithPFUser:row]];
            }
            self.following = result;
            
            NSDictionary *resData = [NSDictionary dictionaryWithObjectsAndKeys:
                                     OPERATION_SUCCEEDED, kOperationResult,
                                     result, kResultFollowing,
                                     nil];
            
            response((id)resData);
        }
    }];
}


- (void)fetchLiveChannelsWithCallback:(SFResponseBlock)response {
    [self queryServerPath:@"/getLive.php"
            requestMethod:@"GET"
               parameters:nil
             withCallback:response];
}

- (void)postMessage:(NSDictionary *)dict withCallback:(SFResponseBlock)response {
    NSString *channel = [dict objectForKey:kMessageChannel];
    NSString *text = [dict objectForKey:kMessageText];
    NSString *name = [dict objectForKey:kMessageName];
    NSString *pictureURL = [dict objectForKey:kMessagePictureURL];
    
    PFObject *newMessage = [PFObject objectWithClassName:@"Comment"];
    [newMessage setObject:channel forKey:kMessageChannel];
    [newMessage setObject:text forKey:kMessageText];
    [newMessage setObject:name forKey:kMessageName];
    [newMessage setObject:pictureURL forKey:kMessagePictureURL];
    
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
                                                                         [row objectForKey:kMessageName], kMessageName,
                                                                         [row objectForKey:kMessageText], kMessageText,
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
