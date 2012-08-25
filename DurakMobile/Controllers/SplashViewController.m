//
//  SplashViewController.m
//  DurakMobile
//
//  Created by Alexander Chernyshev on 24/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "SplashViewController.h"

#import "AppDelegate.h"
#import "GameViewController.h"

@implementation SplashViewController

#pragma mark - lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    GameViewController *controller = [GameViewController new];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate performSelector:@selector(replaceRootViewControllerWithController:) 
                   withObject:controller
                   afterDelay:1.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
@end
