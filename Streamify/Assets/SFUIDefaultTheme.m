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
    if (buttonType == kSFButtonTypeMainColumnDefault) {
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
        image = [[UIImage imageNamed:@"maincol-button-background.png"] resizableImageWithCapInsets:insets];
    } else if (buttonType == kSFButtonTypeMainColumnPressed) {
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
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

@end
