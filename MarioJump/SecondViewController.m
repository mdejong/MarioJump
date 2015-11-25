//
//  SecondViewController.m
//  MarioJump
//
//  Created by Mo DeJong on 11/13/15.
//  Copyright © 2015 helpurock. All rights reserved.
//

#import "SecondViewController.h"

#import "common.h"

#import "AutoTimer.h"

#import "GPUImageView.h"
#import "GPUImageMovie.h"
#import "GPUImageChromaKeyFilter.h"

@interface SecondViewController ()

@property (nonatomic, retain) AutoTimer *timer;

@property (nonatomic, retain) IBOutlet UILabel *label;

@property (nonatomic, retain) IBOutlet GPUImageView *marioView;

@property (nonatomic, retain) GPUImageMovie *movieFile;

@property (nonatomic, retain) GPUImageChromaKeyFilter *filter;

@end

@implementation SecondViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Do any additional setup after loading the view, typically from a nib.
  
  NSAssert(self.label, @"label");
  
  NSAssert(self.marioView, @"marioView");
  
  NSLog( @"viewDidLoad with dimensions %d x %d", (int)self.marioView.frame.size.width, (int)self.marioView.frame.size.height );
  
  self.timer = [AutoTimer autoTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:FALSE];
}

// Create GPUImageMovie and filter. Note that because an asset can only be read once this
// logic need to recreate the movie and filter in order to play the clip again

- (void) makeVideoPlayer
{
  [self.movieFile cancelProcessing];
  self.movieFile = nil;
  
  //self.marioView.backgroundColor = [UIColor blueColor];
  
  //self.marioView.backgroundColor = [UIColor redColor];
  
  //self.marioView.backgroundColor = [UIColor greenColor];
  
  self.marioView.backgroundColor = [UIColor clearColor];
  
  self.marioView.opaque = FALSE;
  
  self.marioView.hidden = FALSE;
  
  // Create GPUImage filter
  
  NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"MarioRendered_960_640_green" withExtension:@"m4v"];
  NSAssert(sampleURL, @"sampleURL");
  GPUImageMovie *movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
  
  GPUImageChromaKeyFilter *filter = [[GPUImageChromaKeyFilter alloc] init];
  
  [filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
  [filter setThresholdSensitivity:0.4];
  
  [movieFile addTarget:filter];
  
  [filter addTarget:self.marioView];
  
  //self.marioView.fillMode = kGPUImageFillModeStretch;
  self.marioView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
  
  [movieFile startProcessing];
  
  self.movieFile = movieFile;
  
  self.filter = filter;
}

// Hide the Label and show Mario

- (void) timerFired {
  self.timer = nil;
  
  self.label.hidden = TRUE;
  
  [self makeVideoPlayer];
  
  return;
}

- (void) viewWillUnload
{
  [super viewWillUnload];
  
  GPUImageMovie *movieFile = self.movieFile;
  
  [movieFile cancelProcessing];
  
  self.movieFile = nil;
  
  self.filter = nil;
}

- (IBAction) jumpButtonPress
{
  NSLog( @"jumpButtonPress with dimensions %d x %d", (int)self.marioView.frame.size.width, (int)self.marioView.frame.size.height );
  
//  BOOL isAnimating = [self.marioMedia isAnimatorRunning];
//  
//  if (isAnimating) {
//    self.marioMedia.animatorRepeatCount += 1;
//  } else {
//    [self.marioMedia startAnimator];
//  }
  
  [self makeVideoPlayer];
  
  return;
}

- (void) viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  NSLog( @"viewDidLayoutSubviews with mario dimensions %d x %d", (int)self.marioView.frame.size.width, (int)self.marioView.frame.size.height );
}

@end
