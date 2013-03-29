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
        [[PFUser currentUser] save];
        
        self.currentUser = [[SFUser alloc] initWithPFUser:[PFUser currentUser]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMeSuccessNotification object:self userInfo:nil];
    }];
    
    return  YES;
}

- (NSArray *)getFollowersForUser:(NSString *)objectID {
    return NULL;
}

- (NSArray *)getFollowsForUser:(NSString *)objectID {
    return NULL;
}


@end
