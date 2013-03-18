//
//  ADModel.h
//  AutoDealer
//
//  Created by Torin on 10/9/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCoding>

- (NSString *)description;

- (id)initWithDictionary:(NSDictionary*)dict;
- (id)updateWithDictionary:(NSDictionary*)dict;
- (id)updateWithModel:(BaseModel*)newModel;
- (id)createCopy;

- (NSDictionary*)toDictionary;
- (NSDictionary*)toDictionaryUseNullValue:(BOOL)useNull;

@end
