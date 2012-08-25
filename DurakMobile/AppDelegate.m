//
//  AppDelegate.m
//  DurakMobile
//
//  Created by Alexander Chernyshev on 24/08/2012.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "AppDelegate.h"

#import "SplashViewController.h"

@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:nil];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)replaceRootViewControllerWithController:(UIViewController *)controller
{
    //__block UIViewController *rootController = self.window.rootViewController;
    self.window.rootViewController = controller;
    /*[controller.view addSubview:rootController.view];
    rootController.view.frame = controller.view.bounds;
    [UIView animateWithDuration:0.25 
                     animations:^{
                         [rootController.view setAlpha:0.0];
                     }
                     completion:^(BOOL flag) {
                         [rootController.view removeFromSuperview];
                         rootController = nil;
                     }
     ];*/
}
@end
