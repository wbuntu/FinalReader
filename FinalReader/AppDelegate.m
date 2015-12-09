//
//  AppDelegate.m
//  FinalReader
//
//  Created by wbuntu on 15/4/28.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "AppDelegate.h"
#import "VolumeManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255.0/255 green:245.0/255 blue:190.0/255 alpha:1]];
    return YES;
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[VolumeManager defaultManager] saveContext];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[VolumeManager defaultManager] saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[VolumeManager defaultManager] saveContext];
}


@end
