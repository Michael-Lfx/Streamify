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
+ (SFSocialManager* )sharedInstance;
- (BOOL)updateMe;
- (void)updateMeWithCallback:(SFResponseBlock)response;
- (NSArray *)getFollowersForUser:(NSString *)objectID;
- (NSArray *)getFollowingForUser:(NSString *)objectID;
- (BOOL)follows:(NSString *)objectID;
- (void)updateLiveChannels;
- (void)updateLiveChannelsWithCallback:(SFResponseBlock)response;
- (void)getFollowingForUser:(NSString *)userID withCallback:(SFResponseBlock)response;
- (void)getFollowersForUser:(NSString *)userID withCallback:(SFResponseBlock)response;
- (void)postMessage:(NSDictionary *)dict withCallback:(SFResponseBlock)response;
- (void)fetchChannelMessages:(NSString *)channelID lastUpdated:(NSDate *)updateTime limit:(NSInteger)limit withCallback:(SFResponseBlock)response;
- (void)fetchChannelMessages:(NSString *)channelID lastUpdated:(NSDate *)updateTime withCallback:(SFResponseBlock)response;
- (void)fetchLiveChannelsWithCallback:(SFResponseBlock)response;
@end
