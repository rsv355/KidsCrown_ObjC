//
//  AppDelegate.m
//  KidsCrown
//
//  Created by webmyne systems on 31/03/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>
#import "Reachability.h"
#import "DataBaseFile.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
 // GET DEVICE ID
    NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"UDID Is-> : %@", Identifier);
    NSLog(@"UserId:-> %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"]);
    
    [[NSUserDefaults standardUserDefaults]setObject:Identifier forKey:@"UDID"];
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] == nil) {
        
        UIViewController *viewController =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LOGIN"];
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        [navigationController pushViewController:viewController animated:YES];
    }
    else {
        UIViewController *viewController =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MENU_DRAWER"];
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        [navigationController pushViewController:viewController animated:YES];
    }
    

    
    if ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] isEqualToString:@"1.3"]) {
  
        [self alterDB];
    }
    
    
    application.applicationIconBadgeNumber = 0;
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
        
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    

    
    return YES;
}

-(void)alterDB
{
    DataBaseFile *dbHandler = [[DataBaseFile alloc]init];
    [dbHandler CopyDatabaseInDevice];
    
    NSString *select = @"ALTER TABLE ProductPrice add COLUMN orderlimit VARCHAR";
    [dbHandler UpdateDataWithQuesy:select];
    
    NSString *select1 = @"ALTER TABLE ProductPrice add COLUMN issingle VARCHAR";
    [dbHandler UpdateDataWithQuesy:select1];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:@"fb107387059640051"])
    {
        //[SVProgressHUD showWithStatus:@"Logging in..."];
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    else
    {
        //[SVProgressHUD showWithStatus:@"Logging in..."];
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
    
    }
    
    return YES;
    
}
- (BOOL)isReachable;
{
    Reachability *reach =[Reachability reachabilityWithHostname:@"www.google.com"];
    return [reach isReachable];
}
+(AppDelegate*)appDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}
    
    
-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
        
        NSString * deviceTokenString = [[[[deviceToken description]
                                          stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                         stringByReplacingOccurrencesOfString:@">" withString:@""]
                                        stringByReplacingOccurrencesOfString: @" " withString: @""];
        
        [[NSUserDefaults standardUserDefaults]setObject:deviceTokenString forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"This is device token %@",deviceTokenString);
        [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:@"Device_Token"];
        
}
-(void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
    {
        NSLog(@"Error %@",err);
    }
    
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateActive)
    {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
}
    
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
        
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

@end
