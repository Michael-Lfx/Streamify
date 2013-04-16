//
//  SFAppDelegate.m
//  Streamify
//
//  Created by Le Viet Tien on 18/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SFAppDelegate.h"
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>


@implementation SFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Load Parse configuration
    [Parse setApplicationId:@"YTD2X45oaoNWDeaBPcVGl2H0bMbN8FSFBwwwZ8nz"
                  clientKey:@"Vm7AvMLG0Gud7vsPSXtJAgBJt1aO24Q0DisRXqvg"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
    
//    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    [TestFlight takeOff:@"b557c4f7-5889-40e9-87bd-d1789b10efdb"];
    
    [self setupApplicationAudio];
    
    return YES;
}

- (void)setupApplicationAudio
{
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
               setCategory: AVAudioSessionCategoryPlayback
               error: &setCategoryError];
    
    if (!success) {
        /* handle the error in setCategoryError */
    }
    
   
    NSError *activationError = nil;
    success = [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    if (!success) {
        /* handle the error in activationError */
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

@end
