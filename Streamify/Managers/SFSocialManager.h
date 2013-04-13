//
//  SFSocialManager.h
//  Streamify
//
//  Created by Le Viet Tien on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFUser.h"

typedef void (^SFResponseBlock)(id returnedObject);

@interface SFSocialManager : NSObject
@property (nonatomic, strong) SFUser *currentUser;
@property (nonatomic, strong) NSArray *liveChannels;
@property (nonatomic, strong) NSArray *followers;
@property (nonatomic, strong) NSArray *following;
@property (nonatomic, strong) NSArray *allUsers;

+ (SFSocialManager* )sharedInstance;
- (void)updateMeWithCallback:(SFResponseBlock)response;
- (BOOL)follows:(NSString *)objectID;
- (void)getFollowingForUser:(NSString *)userID withCallback:(SFResponseBlock)response;
- (void)getFollowersForUser:(NSString *)userID withCallback:(SFResponseBlock)response;
- (void)postMessage:(NSDictionary *)dict withCallback:(SFResponseBlock)response;
- (void)fetchChannelMessages:(NSString *)channelID lastUpdated:(NSDate *)updateTime limit:(NSInteger)limit withCallback:(SFResponseBlock)response;
- (void)fetchChannelMessages:(NSString *)channelID lastUpdated:(NSDate *)updateTime withCallback:(SFResponseBlock)response;
- (void)fetchLiveChannelsWithCallback:(SFResponseBlock)response;

@end
