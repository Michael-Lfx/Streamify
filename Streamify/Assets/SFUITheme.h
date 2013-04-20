//
//  SFUITheme.h
//  Streamify
//
//  Created by Zuyet Awarmatik on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    kSFButtonTypeMainColumnDefault,
    kSFButtonTypeMainColumnPressed
} SFButtonType;

typedef enum {
    kSFSliderMinTrack,
    kSFSliderMaxTrack
} SFSliderTrackType;

@protocol SFUITheme <NSObject>

+ (void)themeButton:(UIButton *)button;
+ (void)themeSlider:(UISlider *)slider;
+ (void)themeSearchBar:(UISearchBar *)searchBar;

+ (UIColor *)mainTextColor;
+ (void)themeButton:(UIButton *)button forType:(SFButtonType)buttonType;

@end
