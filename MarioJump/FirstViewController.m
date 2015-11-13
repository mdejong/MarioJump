//
//  FirstViewController.m
//  MarioJump
//
//  Created by Mo DeJong on 11/13/15.
//  Copyright © 2015 helpurock. All rights reserved.
//

#import "FirstViewController.h"

#define ENABLE_SOUND

@interface FirstViewController ()

@property (nonatomic, retain) IBOutlet UIImageView *buttonImageView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  NSAssert(self.buttonImageView, @"buttonImageView");
}

@end
