//
//  UIViewController+Transition.h
//

#import <UIKit/UIKit.h>

@interface UIViewController (Transition)

- (void)presentModalViewController:(UIViewController *)modalViewController withPushDirection:(NSString *)direction;
- (void)presentModalViewController:(UIViewController *)modalViewController withFadeDuration:(CGFloat)duration;
- (void)dismissModalViewControllerWithPushDirection:(NSString *) direction;
- (void)dismissModalViewControllerWithFadeDuration:(CGFloat)duration;

- (void)forceShowStatusBar;

@end
