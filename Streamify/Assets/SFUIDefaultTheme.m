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
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    [SFUIDefaultTheme themeButton:button forType:kSFButtonTypeMainColumnDefault];
    [SFUIDefaultTheme themeButton:button forType:kSFButtonTypeMainColumnPressed];
}

+ (void)themeSlider:(UISlider *)slider {
    [slider setMinimumTrackImage:[SFUIDefaultTheme getSliderBackgroundImageforType:kSFSliderMinTrack] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[SFUIDefaultTheme getSliderBackgroundImageforType:kSFSliderMaxTrack] forState:UIControlStateNormal];
    [slider setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
}

+ (void)themeSearchBar:(UISearchBar *)searchBar {
    searchBar.backgroundImage = [[UIImage alloc] init];
    [searchBar setSearchFieldBackgroundImage:[SFUIDefaultTheme getSearchBarBackgroundImage] forState:UIControlStateNormal];
    
    [searchBar setImage:[UIImage imageNamed:@"ui-searchbar-icon-search.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"ui-searchbar-icon-cancel.png"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.textColor = [SFUIDefaultTheme mainTextColor];
    searchField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
}

+ (void)themeTextField:(UITextField *)textField {
    [textField setBackground:[SFUIDefaultTheme getTextFieldBackgroundImage]];
    textField.textColor = [SFUIDefaultTheme mainTextColor];
    textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
}

+ (void)themeSegmentedControl:(UISegmentedControl *)segmentedControl {
    [segmentedControl setBackgroundImage:[SFUIDefaultTheme getSegmentedControlBackgroundImageForState:UIControlStateNormal]
                       forState:UIControlStateNormal
                     barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:[SFUIDefaultTheme getSegmentedControlBackgroundImageForState:UIControlStateSelected]
                                forState:UIControlStateSelected
                              barMetrics:UIBarMetricsDefault];
    
    [segmentedControl setDividerImage:[SFUIDefaultTheme getSegmentedControlSeparatorImage]
      forLeftSegmentState:UIControlStateNormal
        rightSegmentState:UIControlStateNormal
               barMetrics:UIBarMetricsDefault];
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

+ (UIImage *)getSearchBarBackgroundImage {
    UIImage *image;
    UIEdgeInsets insets = UIEdgeInsetsMake(15, 20, 15, 20);
    image = [[UIImage imageNamed:@"ui-searchbox.png"] resizableImageWithCapInsets:insets];
    return image;
}

+ (UIImage *)getTextFieldBackgroundImage {
    UIImage *image;
    UIEdgeInsets insets = UIEdgeInsetsMake(15, 20, 15, 20);
    image = [[UIImage imageNamed:@"ui-searchbox.png"] resizableImageWithCapInsets:insets];
    return image;
}

+ (UIImage *)getSegmentedControlBackgroundImageForState:(UIControlState)state {
    UIImage *image;
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
    if (state == UIControlStateNormal) {
        image = [[UIImage imageNamed:@"ui-segmented-unselected.png"] resizableImageWithCapInsets:insets];
    } else if (state == UIControlStateSelected) {
        image = [[UIImage imageNamed:@"ui-segmented-selected.png"] resizableImageWithCapInsets:insets];
    }
    return image;
}

+ (UIImage *)getSegmentedControlSeparatorImage {
    return [UIImage imageNamed:@"ui-segmented-separator"];
}

@end
