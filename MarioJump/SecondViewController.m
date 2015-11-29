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
#import "GPUImageChromaKeyBlendFilter.h"
#import "GPUImagePicture.h"

@interface SecondViewController ()

@property (nonatomic, retain) AutoTimer *timer;

@property (nonatomic, retain) IBOutlet UILabel *label;

@property (nonatomic, retain) IBOutlet GPUImageView *marioView;

@property (nonatomic, retain) GPUImagePicture *sourcePicture;

@property (nonatomic, retain) GPUImageMovie *movieFile;

@property (nonatomic, retain) id filter;

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
  
  //self.marioView.backgroundColor = [UIColor clearColor];
  
  if ((0)) {
    NSString *resFilename = @"checkerboard_background.png";
    NSString *resPath = [self.class getResourcePath:resFilename];
    UIImage *img = [UIImage imageWithContentsOfFile:resPath];
    UIColor *pattern = [UIColor colorWithPatternImage:img];
    [self.marioView setBackgroundColor:pattern];
  }
  
  if ((0)) {
    NSString *resFilename = @"empty.png";
    NSString *resPath = [self.class getResourcePath:resFilename];
    UIImage *img = [UIImage imageWithContentsOfFile:resPath];
    UIColor *pattern = [UIColor colorWithPatternImage:img];
    [self.marioView setBackgroundColor:pattern];
    
//    self.marioView.backgroundColor = [UIColor clearColor];
//    [self.marioView setBackgroundColorRed:0.0 green:0.0 blue:0.0 alpha:0.0];
  }

  if ((1)) {
    self.marioView.backgroundColor = [UIColor clearColor];
    
    [self.marioView setBackgroundColorRed:0.0 green:0.0 blue:0.0 alpha:0.0];
  }
  
//  self.marioView.opaque = TRUE;
  self.marioView.opaque = FALSE;
  
  self.marioView.hidden = FALSE;
  
  // Create GPUImage filter
  
  NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"MarioRendered_960_640_green" withExtension:@"m4v"];
  NSAssert(sampleURL, @"sampleURL");
  GPUImageMovie *movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
  
#if defined(GPUIMAGEWORKAROUND)
  GPUImageChromaKeyBlendFilter *filter = [[GPUImageChromaKeyBlendFilter alloc] init];
#else
  GPUImageChromaKeyFilter *filter = [[GPUImageChromaKeyFilter alloc] init];
#endif // GPUIMAGEWORKAROUND
  
  [filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
  [filter setThresholdSensitivity:0.4];
  
  [movieFile addTarget:filter];
  
#if defined(GPUIMAGEWORKAROUND)
//  NSString *resFilename = @"checkerboard_background.png";
  NSString *resFilename = @"empty.png";
  UIImage *inputImage = [UIImage imageNamed:resFilename];
  GPUImagePicture *sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
  [sourcePicture addTarget:filter];
  self.sourcePicture = sourcePicture;
#else
#endif // GPUIMAGEWORKAROUND
  
  [filter addTarget:self.marioView];
  
  //self.marioView.fillMode = kGPUImageFillModeStretch;
  self.marioView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
  
  self.movieFile = movieFile;
  
  self.filter = filter;
}

// Hide the Label and show Mario

- (void) timerFired {
  self.timer = nil;
  
  self.label.hidden = TRUE;
  
  [self makeVideoPlayer];
  
  [self.movieFile startProcessing];
  
#if defined(GPUIMAGEWORKAROUND)
  [self.sourcePicture processImage];
#endif // GPUIMAGEWORKAROUND
  
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
  
  [self makeVideoPlayer];
  
  [self.movieFile startProcessing];
  
#if defined(GPUIMAGEWORKAROUND)
  [self.sourcePicture processImage];
#endif // GPUIMAGEWORKAROUND
  
  return;
}

- (void) viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  NSLog( @"viewDidLayoutSubviews with mario dimensions %d x %d", (int)self.marioView.frame.size.width, (int)self.marioView.frame.size.height );
}

+ (NSString*) getResourcePath:(NSString*)resFilename
{
  NSBundle* appBundle = [NSBundle mainBundle];
  NSString* movieFilePath = [appBundle pathForResource:resFilename ofType:nil];
  NSAssert(movieFilePath, @"movieFilePath is nil");
  return movieFilePath;
}

@end
