//
//  SFUser.h
//  Streamify
//
//  Created by Le Viet Tien on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface SFUser : BaseModel
- (id)initWithPFUser:(PFUser *)user;
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *facebookId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pictureURL;
@end
