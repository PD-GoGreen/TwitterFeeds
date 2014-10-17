//
//  AppDelegate.m
//  TwitterFeeds
//
//  Created by Pradnya on 10/15/14.
//  Copyright (c) 2014 Pradnya. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    FeedsViewController* feedsViewController = [[FeedsViewController alloc] init];
    self.rootViewController = [[UINavigationController alloc] initWithRootViewController:feedsViewController];
    self.window.rootViewController = self.rootViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
