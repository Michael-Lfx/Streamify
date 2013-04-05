//
//  SFUIDefaultTheme.m
//  Streamify
//
//  Created by Zuyet Awarmatik on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFUIDefaultTheme.h"

@implementation SFUIDefaultTheme

+ (void)themeButton:(UIButton *)button {
    [SFUIDefaultTheme themeButton:button forType:kSFButtonTypeMainColumnDefault];
    [SFUIDefaultTheme themeButton:button forType:kSFButtonTypeMainColumnPressed];
}

+ (void)themeSlider:(UISlider *)slider {
    [slider setMinimumTrackImage:[SFUIDefaultTheme getSliderBackgroundImageforType:kSFSliderMinTrack] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[SFUIDefaultTheme getSliderBackgroundImageforType:kSFSliderMaxTrack] forState:UIControlStateNormal];
    [slider setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
}

+ (UIColor *)mainTextColor {
    return [UIColor colorWithRed:101.0/255 green:246.0/255 blue:227.0/255 alpha:1];
}

+ (void)themeButton:(UIButton *)button forType:(SFButtonType)buttonType {
    button.opaque = NO;

    UIImage *image = [SFUIDefaultTheme getButtonBackgroundImageforType:buttonType];
    
    if (buttonType == kSFButtonTypeMainColumnDefault) {
        
        // Set background
        [button setBackgroundImage:image
                          forState:UIControlStateNormal];
        
        // Set text color
        [button setTitleColor:[SFUIDefaultTheme getButtonTextColorForType:buttonType]
                     forState:UIControlStateNormal];
        
    } else if (buttonType == kSFButtonTypeMainColumnPressed) {
        
        // Set background
        [button setBackgroundImage:image
                          forState:UIControlStateSelected];
        [button setBackgroundImage:image
                          forState:UIControlStateSelected | UIControlStateHighlighted];
        
        // Set text color
        [button setTitleColor:[SFUIDefaultTheme getButtonTextColorForType:buttonType]
                     forState:UIControlStateSelected];
        [button setTitleColor:[SFUIDefaultTheme getButtonTextColorForType:buttonType]
                     forState:UIControlStateSelected | UIControlStateHighlighted];
    }
}

+ (UIImage *)getButtonBackgroundImageforType:(SFButtonType)buttonType {
    UIImage *image;
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    if (buttonType == kSFButtonTypeMainColumnDefault) {
        image = [[UIImage imageNamed:@"maincol-button-background.png"] resizableImageWithCapInsets:insets];
    } else if (buttonType == kSFButtonTypeMainColumnPressed) {
        image = [[UIImage imageNamed:@"maincol-button-background-pressed.png"] resizableImageWithCapInsets:insets];
    }
    return image;
}

+ (UIColor *)getButtonTextColorForType:(SFButtonType)buttonType {
    if (buttonType == kSFButtonTypeMainColumnDefault) {
        return [SFUIDefaultTheme mainTextColor];
    } else if (buttonType == kSFButtonTypeMainColumnPressed) {
        return [SFUIDefaultTheme mainTextColor];
    }
    return NULL;
}

+ (UIImage *)getSliderBackgroundImageforType:(SFSliderTrackType)sliderTrackType {
    UIImage *image;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 2, 0, 2);
    if (sliderTrackType == kSFSliderMinTrack) {
        image = [[UIImage imageNamed:@"topbar-track-min.png"] resizableImageWithCapInsets:insets];
    } else if (sliderTrackType == kSFSliderMaxTrack) {
        image = [[UIImage imageNamed:@"topbar-track-max.png"] resizableImageWithCapInsets:insets];
    }
    return image;
}

@end
