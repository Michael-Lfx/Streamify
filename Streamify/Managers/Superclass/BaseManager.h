//
//  BaseManager.h
//  AutoDealer
//
//  Created by Torin on 4/12/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseManager : NSObject

+ (id)sharedInstance;

- (NSMutableArray *)getDataArray;

+ (NSData*)loadJSONDataFromFileName:(NSString*)filename;
+ (id)loadJSONObjectFromFileName:(NSString*)filename;

@end
