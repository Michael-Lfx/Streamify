//
//  SFPlaylistItem.h
//  Streamify
//
//  Created by Le Viet Tien on 19/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "BaseModel.h"

@interface SFPlaylistItem : BaseModel
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *albumName;
@end
