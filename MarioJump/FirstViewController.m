//
//  FirstViewController.m
//  MarioJump
//
//  Created by Mo DeJong on 11/13/15.
//  Copyright © 2015 helpurock. All rights reserved.
//

#import "FirstViewController.h"

#import "AutoTimer.h"

#import "common.h"

#import "AVAnimatorView.h"

#import "AVAnimatorMedia.h"

#import "AVMvidFrameDecoder.h"

#import "AVAssetJoinAlphaResourceLoader.h"

#import "AVFileUtil.h"

@interface FirstViewController ()

@property (nonatomic, retain) AutoTimer *timer;

@property (nonatomic, retain) IBOutlet UIButton *button;

@property (nonatomic, retain) IBOutlet UILabel *label;

@property (nonatomic, retain) IBOutlet AVAnimatorView *marioView;

@property (nonatomic, retain) AVAnimatorMedia *marioMedia;

@end

@implementation FirstViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  NSAssert(self.label, @"label");
  
  NSAssert(self.button, @"button");

  NSAssert(self.marioView, @"marioView");
  
  self.marioView.hidden = TRUE;
  
  self.timer = [AutoTimer autoTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:FALSE];

  self.marioMedia = [AVAnimatorMedia aVAnimatorMedia];
  
  [self prepareMedia];
}

// Prep the mario media

- (void) prepareMedia
{
  NSString *rgbResourceName;
  NSString *alphaResourceName;
  NSString *rgbTmpMvidFilename;
  NSString *rgbTmpMvidPath;
  
  rgbResourceName = @"MarioRendered_960_640_rgb_CRF_20_24BPP.m4v";
  alphaResourceName = @"MarioRendered_960_640_alpha_CRF_20_24BPP.m4v";
  rgbTmpMvidFilename = @"MarioRendered.mvid";

  rgbTmpMvidPath = [AVFileUtil getTmpDirPath:rgbTmpMvidFilename];
  
  NSLog(@"loading %@", rgbTmpMvidPath);
  
  AVAnimatorMedia *media = [AVAnimatorMedia aVAnimatorMedia];
  
  self.marioMedia = media;
  
  AVAssetJoinAlphaResourceLoader *resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
  
  resLoader.movieRGBFilename = rgbResourceName;
  resLoader.movieAlphaFilename = alphaResourceName;
  resLoader.outPath = rgbTmpMvidPath;
  resLoader.alwaysGenerateAdler = TRUE;
  
  media.resourceLoader = resLoader;
  
  AVMvidFrameDecoder *frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  media.frameDecoder = frameDecoder;

#if defined(ENABLE_SOUND)
  if ((0)) {
  resLoader.audioFilename = @"sm64_mario_hoohoo.wav";
  }
#endif

  // Play slowly at half speed
  media.animatorFrameDuration = AVAnimator5FPS;
  
  // Play video quickly (as opposed to 10 FPS)
//  media.animatorFrameDuration = AVAnimator24FPS;
  
  [media prepareToAnimate];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(animatorDoneNotification:)
                                               name:AVAnimatorDoneNotification
                                             object:media];
  
  return;
}

// When done animating a clip, rewind to frame 0 so that Mario's eye close

- (void)animatorDoneNotification:(NSNotification*)notification {
  NSLog( @"animatorDoneNotification" );
  
  if (self.marioMedia.animatorRepeatCount > 0) {
    // nop since looping
    NSLog( @"animatorDoneNotification : already looping" );
  } else {
//    NSLog( @"animatorDoneNotification : show frame 0 for eyes closed" );
//    [self.marioMedia showFrame:0];

    NSLog( @"animatorDoneNotification : show frame 0 for eyes open" );
    [self.marioMedia showFrame:1];
  }
}

- (void) viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  NSLog( @"viewDidLayoutSubviews with mario dimensions %d x %d", (int)self.marioView.frame.size.width, (int)self.marioView.frame.size.height );
}

// Hide the Label and show Mario

- (void) timerFired {
  self.timer = nil;

  self.label.hidden = TRUE;
  
//  self.marioView.backgroundColor = [UIColor greenColor];
//  self.marioView.backgroundColor = [UIColor blueColor];
//  self.marioView.backgroundColor = [UIColor redColor];
//  self.marioView.backgroundColor = [UIColor clearColor];
  
  self.marioView.hidden = FALSE;
  
  if ((0)) {
    // PHony logic to show an alpha channel X over the background
    self.marioView.image = [UIImage imageNamed:@"X"];
  }
  
  [self.marioView attachMedia:self.marioMedia];

  [self.marioMedia startAnimator];
  
  return;
}

- (IBAction) jumpButtonPress
{
  NSLog( @"jumpButtonPress with dimensions %d x %d", (int)self.marioView.frame.size.width, (int)self.marioView.frame.size.height );
  
  BOOL isAnimating = [self.marioMedia isAnimatorRunning];
  
  if (isAnimating) {
    self.marioMedia.animatorRepeatCount += 1;
  } else {
    [self.marioMedia startAnimator];
  }
  
  return;
}

@end
