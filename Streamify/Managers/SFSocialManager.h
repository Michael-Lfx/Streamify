//
//  SFSocialManager.h
//  Streamify
//
//  Created by Le Viet Tien on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFUser.h"

@interface SFSocialManager : NSObject
@property (nonatomic, strong) SFUser *currentUser;
+ (SFSocialManager* )sharedInstance;
- (BOOL)updateMe;
- (NSArray *)getFollowersForUser:(NSString *)objectID;
- (NSArray *)getFollowingForUser:(NSString *)objectID;
- (BOOL)follows:(NSString *)objectID;
@end
