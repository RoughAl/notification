//
//  AppDelegate.m
//  notification
//
//  Created by 白 桦 on 9/7/15.
//  Copyright (c) 2015 白 桦. All rights reserved.
//

#import "AppDelegate.h"
#import "EspViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    }
    
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    
    // update my token in UI
    EspViewController *vc = (EspViewController *)self.window.rootViewController;
    NSString *token = [self getHexStringByData:deviceToken];
    NSLog(@"label token: %@",token);
    vc.labelToken.text = token;
}

- (NSString *) getHexStringByData:(NSData *)data
{
    NSMutableString* mStr = [[NSMutableString alloc]init];
    NSUInteger totalLen = [data length];
    Byte bytes[totalLen];
    [data getBytes:&bytes length:totalLen];
    for (int i = 0; i < totalLen; i++)
    {
        if (i!=0 && i%4==0)
        {
            [mStr appendString:@" "];
        }
        NSString *hexString = [[NSString alloc]initWithFormat:@"%.2x",bytes[i]];
        [mStr appendString:hexString];
    }
    return mStr;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to get token, error: %@", error);
    
    // update my token in UI
    EspViewController *vc = (EspViewController *)self.window.rootViewController;
    vc.labelToken.text = [NSString stringWithFormat:@"Failed to get token, error: %@",error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Remote notification arrived: %@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}

@end
