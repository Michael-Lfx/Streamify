//
//  UiViewController+Transitions.m
//

#import <QuartzCore/QuartzCore.h>
#import "UIViewController+Transition.h"

@implementation UIViewController(Transitions)

- (void)presentModalViewController:(UIViewController *)modalViewController withPushDirection:(NSString *)direction
{
  [CATransaction begin];
  
  CATransition *transition = [CATransition animation];
  transition.type = kCATransitionPush;
  transition.subtype = direction;
  transition.duration = 0.25f;
  transition.fillMode = kCAFillModeForwards;
  transition.removedOnCompletion = YES;
  
  [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [CATransaction setCompletionBlock: ^ {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
      [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
  }];
  
  [self presentModalViewController:modalViewController animated:NO];
  
  [CATransaction commit];
}

- (void)presentModalViewController:(UIViewController *)modalViewController withFadeDuration:(CGFloat)duration
{
  [CATransaction begin];
  
  CATransition *transition = [CATransition animation];
  transition.type = kCATransitionFade;
  transition.duration = duration;
  transition.fillMode = kCAFillModeForwards;
  transition.removedOnCompletion = YES;
  
  [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [CATransaction setCompletionBlock: ^ {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
      [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
  }];
  
  [self presentModalViewController:modalViewController animated:NO];
  
  [CATransaction commit];
}

- (void)dismissModalViewControllerWithPushDirection:(NSString *)direction
{  
  [CATransaction begin];
  
  CATransition *transition = [CATransition animation];
  transition.type = kCATransitionPush;
  transition.subtype = direction;
  transition.duration = 0.25f;
  transition.fillMode = kCAFillModeForwards;
  transition.removedOnCompletion = YES;
  
  [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [CATransaction setCompletionBlock: ^ {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
      [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
  }];
  
  [self dismissModalViewControllerAnimated:NO];
  
  [CATransaction commit];
}

- (void)dismissModalViewControllerWithFadeDuration:(CGFloat)duration
{
  [CATransaction begin];
  
  CATransition *transition = [CATransition animation];
  transition.type = kCATransitionFade;
  transition.duration = duration;
  transition.fillMode = kCAFillModeForwards;
  transition.removedOnCompletion = YES;
  
  [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:@"transition"];
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [CATransaction setCompletionBlock: ^ {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
      [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
  }];
  
  [self dismissModalViewControllerAnimated:NO];
  
  [CATransaction commit];
}


- (void)forceShowStatusBar
{
  //Hack to fix statusbar covers UINavigationBar
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  [self.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
