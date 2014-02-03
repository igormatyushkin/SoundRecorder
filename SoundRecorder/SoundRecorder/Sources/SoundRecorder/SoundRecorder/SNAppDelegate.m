//
//  SNAppDelegate.m
//  SoundRecorder
//
//  Created by Igor Matyushkin on 03.02.14.
//  Copyright (c) 2014 NoCompany. All rights reserved.
//

#import "SNAppDelegate.h"
#import "SNMainViewController.h"
#import "SNSplashViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@implementation SNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self showSplashScreen];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        [self showAppScreen];
        
        DBSession* dbSession = [[DBSession alloc] initWithAppKey:Dropbox_AppKey
                                                       appSecret:Dropbox_AppSecret
                                                            root:kDBRootAppFolder];
        [DBSession setSharedSession:dbSession];
    });
    
    return YES;
}

- (void)showSplashScreen
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[SNSplashViewController defaultSplashViewController]];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
    navigationController = nil;
}

- (void)showAppScreen
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[SNMainViewController defaultMainViewController]];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
    navigationController = nil;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if([[DBSession sharedSession] handleOpenURL:url])
    {
        if([[DBSession sharedSession] isLinked])
        {
            NSLog(@"App linked successfully!");
        }
        else
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[DBSession sharedSession] linkFromController:[SNMainViewController defaultMainViewController]];
            });
        }
        
        return YES;
    }
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
