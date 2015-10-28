//
//  AppDelegate.m
//  AllychatDemo
//
//  Created by Alexandr Turyev on 25/10/15.
//  Copyright © 2015 Octoberry. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    #warning Please input APPLICATION ID and URL
    
//    [AllychatSDK initWithAppId:@"mobile" andUrl:@"https://my-dev.allychat.ru"];
    [AllychatSDK initWithAppId:@"sense" andUrl:@"https://alfa-dev.allychat.ru"];
    /*
     Make your app register for remote notifications
     */
    [self registerForPushNotifications];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Remote Notifications stack

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
        NSLog(@"Push-notifications support was declined");
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
        
    }
}
#endif

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    /*
     Register device for push notifications
     */
    [AllychatSDK subscribeToAPNSWithToken:deviceToken failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *aps = userInfo[@"aps"];
    NSString *alertMessage = aps[@"alert"];
    if (alertMessage) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:alertMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get push token, error: %@", error);
}

#pragma mark - Push Notifications

-(void)registerForPushNotifications
{
    UIApplication *sharedApp = [UIApplication sharedApplication];
    if ([sharedApp respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert) categories:nil];
        [sharedApp registerUserNotificationSettings: settings];
    }
    else
    {
        [sharedApp registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

@end
