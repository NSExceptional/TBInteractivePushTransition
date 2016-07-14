//
//  TBAppDelegate.m
//  TBInteractivePushTransition
//
//  Created by ThePantsThief on 07/14/2016.
//  Copyright (c) 2016 ThePantsThief. All rights reserved.
//

#import "TBAppDelegate.h"
#import "TBViewController.h"


@implementation TBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[TBViewController new]];
    
    return YES;
}

@end
