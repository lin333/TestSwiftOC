//
//  TBAppDelegate.m
//  TBBaseKit
//
//  Created by linbingjie on 2021/3/1.
//

#import "TBBaseAppDelegate.h"
#import "TBModuleManager.h"

@implementation TBBaseAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return [[TBModuleManager sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options
{
    return [[TBModuleManager sharedInstance] application:app openURL:url options:options];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[TBModuleManager sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[TBModuleManager sharedInstance] applicationWillEnterForeground:application];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[TBModuleManager sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[TBModuleManager sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
    [[TBModuleManager sharedInstance] application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[TBModuleManager sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[TBModuleManager sharedInstance] applicationWillResignActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[TBModuleManager sharedInstance] applicationWillTerminate:application];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[TBModuleManager sharedInstance] applicationDidReceiveMemoryWarning:application];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler
{
    [[TBModuleManager sharedInstance] application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[TBModuleManager sharedInstance] application:application performFetchWithCompletionHandler:completionHandler];
}

- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler
{
    return [[TBModuleManager sharedInstance] application:application
                                    continueUserActivity:userActivity
                                      restorationHandler:restorationHandler];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[TBModuleManager sharedInstance] application:application
                     didReceiveRemoteNotification:userInfo
                           fetchCompletionHandler:completionHandler];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier {
    return [[TBModuleManager sharedInstance] application:application shouldAllowExtensionPointIdentifier:extensionPointIdentifier];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[TBModuleManager sharedInstance] application:application handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[TBModuleManager sharedInstance] application:application
                                                 openURL:url
                                       sourceApplication:sourceApplication
                                              annotation:annotation];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    [[TBModuleManager sharedInstance] application:application didRegisterUserNotificationSettings:notificationSettings];
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    [[TBModuleManager sharedInstance] application:application
                       handleActionWithIdentifier:identifier
                             forLocalNotification:notification
                                completionHandler:completionHandler];
}

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(nonnull void (^)(void))completionHandler
{
    [[TBModuleManager sharedInstance] application:application
                       handleActionWithIdentifier:identifier
                            forRemoteNotification:userInfo
                                completionHandler:completionHandler];
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[TBModuleManager sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification
{
    [[TBModuleManager sharedInstance] application:application didReceiveLocalNotification:notification];
}

@end

