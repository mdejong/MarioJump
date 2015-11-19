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

@interface SecondViewController ()

@property (nonatomic, retain) AutoTimer *timer;

@property (nonatomic, retain) IBOutlet UILabel *label;

@end

@implementation SecondViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Do any additional setup after loading the view, typically from a nib.
  
  NSAssert(self.label, @"label");
  
  self.timer = [AutoTimer autoTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:FALSE];
}

// Hide the Label and show Mario

- (void) timerFired {
  self.timer = nil;
  
  self.label.hidden = TRUE;
  
  //  self.marioView.backgroundColor = [UIColor greenColor];
  //  self.marioView.backgroundColor = [UIColor blueColor];
  //  self.marioView.backgroundColor = [UIColor redColor];
  //  self.marioView.backgroundColor = [UIColor clearColor];
  
//  self.marioView.hidden = FALSE;
//  
//  [self.marioView attachMedia:self.marioMedia];
//  
//  [self.marioMedia startAnimator];
  
  return;
}

@end
