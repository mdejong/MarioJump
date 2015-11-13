//
//  AppDelegate.m
//  MarioJump
//
//  Created by Mo DeJong on 11/13/15.
//  Copyright © 2015 helpurock. All rights reserved.
//

#import "AppDelegate.h"

#import "AutoTimer.h"

#import "common.h"

#ifdef ENABLE_SOUND
#import <AVFoundation/AVAudioPlayer.h>
#endif // ENABLE_SOUND

@interface AppDelegate ()

@property (nonatomic, retain) AVAudioPlayer *introAudioPlayer;

@property (nonatomic, retain) AutoTimer *introAudioTimer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  
#ifdef ENABLE_SOUND
  {
    NSString *resFilename = @"sm64_mario_its_me.wav";
    NSString* resPath = [[NSBundle mainBundle] pathForResource:resFilename ofType:nil];
    NSAssert(resPath, @"resPath is nil");
    NSURL *url = [NSURL fileURLWithPath:resPath];
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    self.introAudioPlayer = player;
    
    [self.introAudioPlayer prepareToPlay];
    [self.introAudioPlayer play];
    
    self.introAudioTimer = [AutoTimer autoTimerWithTimeInterval:2.0 target:self selector:@selector(timerFired) userInfo:nil repeats:FALSE];
  }
#endif // ENABLE_SOUND
  
  return YES;
}

- (void) timerFired {
  self.introAudioTimer = nil;
  
  [self.introAudioPlayer stop];
  self.introAudioPlayer = nil;
  
  return;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
