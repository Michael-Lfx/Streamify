//
//  SFAudioSession.m
//  Streamify
//
//  Created by Le Minh Tu on 4/17/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SFAudioSession.h"

#pragma mark Audio session callbacks_______________________

void audioRouteChangeListenerCallback (void                      *inUserData,
                                       AudioSessionPropertyID    inPropertyID,
                                       UInt32                    inPropertyValueSize,
                                       const void                *inPropertyValue
                                       ) {
	
	// ensure that this callback was invoked for a route change
	if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
    
	// This callback, being outside the implementation block, needs a reference to the
	//		MainViewController object, which it receives in the inUserData parameter.
	//		You provide this reference when registering this callback (see the call to
	//		AudioSessionAddPropertyListener).
//	MainViewController *controller = (MainViewController *) inUserData;
	
	// if application sound is not playing, there's nothing to do, so return.
//	if (controller.appSoundPlayer.playing == 0 ) {
//        
//		NSLog (@"Audio route change while application audio is stopped.");
//		return;
//		
//	} else {
    
		// Determines the reason for the route change, to ensure that it is not
		//		because of a category change.
		CFDictionaryRef	routeChangeDictionary = inPropertyValue;
		
		CFNumberRef routeChangeReasonRef =
        CFDictionaryGetValue (
                              routeChangeDictionary,
                              CFSTR (kAudioSession_AudioRouteChangeKey_Reason)
                              );
        
		SInt32 routeChangeReason;
		
		CFNumberGetValue (
                          routeChangeReasonRef,
                          kCFNumberSInt32Type,
                          &routeChangeReason
                          );
		
		// "Old device unavailable" indicates that a headset was unplugged, or that the
		//	device was removed from a dock connector that supports audio output. This is
		//	the recommended test for when to pause audio.
		if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
            
//			[controller.appSoundPlayer pause];
			NSLog (@"Output device removed, so application audio was paused.");
            
//			UIAlertView *routeChangeAlertView =
//            [[UIAlertView alloc]	initWithTitle: NSLocalizedString (@"Playback Paused", @"Title for audio hardware route-changed alert view")
//                                       message: NSLocalizedString (@"Audio output was changed", @"Explanation for route-changed alert view")
//                                      delegate: controller
//                             cancelButtonTitle: NSLocalizedString (@"StopPlaybackAfterRouteChange", @"Stop button title")
//                             otherButtonTitles: NSLocalizedString (@"ResumePlaybackAfterRouteChange", @"Play button title"), nil];
//			[routeChangeAlertView show];
			// release takes place in alertView:clickedButtonAtIndex: method
            
		} else {
            
			NSLog (@"A route change occurred that does not require pausing of application audio.");
		}
//	}
}



@implementation SFAudioSession

+ (SFAudioSession *)sharedInstance
{
    static SFAudioSession *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (void)setup
{
    // Set audio session category
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
    
    // Register audio route change listener
    AudioSessionAddPropertyListener (
                                     kAudioSessionProperty_AudioRouteChange,
                                     audioRouteChangeListenerCallback,
                                     (__bridge void *)(self)
                                     );
    
    // Explicitly activate audio session
    NSError *activationError = nil;
	[[AVAudioSession sharedInstance] setActive: YES error: &activationError];
}

@end
