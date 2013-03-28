//
//  TileModel.h
//  Metro
//
//  Created by Le Minh Tu on 3/27/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFTileModel <NSObject>

- (NSString *)title;
- (UIImage *)cover;

@end

@interface SFTileModel : NSObject <SFTileModel>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *cover;

- (id)initWithName:(NSString *)name andCover:(UIImage *)cover;

@end
