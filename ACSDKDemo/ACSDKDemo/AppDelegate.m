//
//  AppDelegate.m
//  ACSDK
//
//  Created by Andrew Kopanev on 12/16/15.
//  Copyright © 2015 Magneta. All rights reserved.
//

#import "AppDelegate.h"
#import <ACSDK/ACSDK.h>

#import "ACLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ACSDK defaultInstance].logLevel = ACSDKLogDebug;
    [[ACSDK defaultInstance] setApplicationId:@"app" serverURL:[NSURL URLWithString:@"https://my-dev.allychat.ru"]];
    [ACSDK defaultInstance].setReadForAllDeliveredMessages = NO;
    
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:56/255.0 green:57/255.0 blue:87/255.0 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ACLoginViewController new]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    if (deviceToken)
        [[ACSDK defaultInstance] subscribeToAPNs:deviceToken];
}

@end
