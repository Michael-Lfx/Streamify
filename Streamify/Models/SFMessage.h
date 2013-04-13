//
//  SFMessage.h
//  Streamify
//
//  Created by Le Viet Tien on 12/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseModel.h"

@interface SFMessage : BaseModel

@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pictureURL;
@end
