//
//  AppDelegate.m
//  Homepwner
//
//  Created by Ricky Pattillo on 12/20/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import "AppDelegate.h"
#import "ItemsViewController.h"
#import "ItemStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   self.window.backgroundColor = [UIColor whiteColor];

   return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   if (!self.window.rootViewController) {
      ItemsViewController *itemsVC = [[ItemsViewController alloc] init];
      UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:itemsVC];
      navVC.restorationIdentifier = NSStringFromClass([navVC class]);
      self.window.rootViewController = navVC;
   }
   
   [self.window makeKeyAndVisible];
   
   return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
   // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
   // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

   BOOL success = [[ItemStore sharedStore] saveChanges];
   if (success) {
      NSLog( @"Saved all of the Items");
   }
   else {
      NSLog(@"Could not save any of the Items");
   }
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


#pragma mark - State Restoration

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
   return YES;
}


- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
   return YES;
}


- (UIViewController *)application:(UIApplication *)application
   viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                            coder:(NSCoder *)coder
{
   UIViewController *vc = [[UINavigationController alloc] init];
   vc.restorationIdentifier = [identifierComponents lastObject];

   if ([identifierComponents count] == 1) {
      self.window.rootViewController = vc;
   }

   return vc;
}

@end
