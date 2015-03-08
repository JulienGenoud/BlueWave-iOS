//
//  AppDelegate.m
//  BlueWave
//
//  Created by Rémi Hillairet on 27/10/14.
//  Copyright (c) 2014 Rémi Hillairet. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "Define.h"
#import "LocalData.h"

@import CoreLocation;

@interface AppDelegate ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if (![prefs boolForKey:@"alreadyLaunch"]) {
        [prefs setBool:YES forKey:SETTINGS_NOTIFICATIONS];
        [prefs setBool:YES forKey:@"alreadyLaunch"];
        [prefs synchronize];
    }
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    return YES;
}

//-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
//    NSLog(@"AppDelegate ENTER REGION : \n%@", region);
//    CLBeaconRegion *beacon = (CLBeaconRegion*)region;
//    NSLog(@"Beacon detected : %@", beacon);
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    if ([prefs boolForKey:SETTINGS_NOTIFICATIONS]) {
//        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//        localNotification.fireDate = [NSDate date];
//        localNotification.alertBody = @"Une balise Bluewave a été détectée";
//        localNotification.timeZone = [NSTimeZone defaultTimeZone];
//        localNotification.soundName = UILocalNotificationDefaultSoundName;
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//    }
//}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"AppDelegate EXIT REGION : \n%@", region);

}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    NSLog(@"AppDelegate Detect region");
    CLBeaconRegion *beacon = (CLBeaconRegion*)region;
    NSLog(@"Beacon detected : %@", beacon);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"Enter in background");
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

@end
