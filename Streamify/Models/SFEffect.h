//
//  SFEffect.h
//  Streamify
//
//  Created by Le Viet Tien on 23/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseModel.h"

@interface SFEffect : BaseModel

@property (nonatomic, strong) NSString *effectName;
@property (nonatomic, strong) NSURL *URL;

- (id)initWithName:(NSString *)effectName URL:(NSURL *)URL;

@end
