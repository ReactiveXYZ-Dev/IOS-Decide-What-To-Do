//
//  AppDelegate.m
//  Decide:decide what to do
//
//  Created by YINGGUANG CHEN on 4/10/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "RoleObject.h"
#import "DCForGroupObject.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // some tests
    NSArray* listOfRoles = @[[RoleObject roleWithName:@"Jackie"],[RoleObject roleWithName:@"Echo"],[RoleObject roleWithName:@"Effie"]];
    
    NSArray* listOfTasks = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    
    DCForGroupObject* groupModel = [[DCForGroupObject alloc]initWithRoleList:listOfRoles AndTasks:listOfTasks];
    
    [groupModel assignExtraTasks:groupModel.getNumOfExtraTasksSomeoneHasToDo ToRoleWithName:@"Jackie"];
    
    [groupModel assignExtraChance:20 OfDoingTaskNamed:@"2" ToRoleWithName:@"Jackie"];
    [groupModel assignExtraChance:100 OfDoingTaskNamed:@"2" ToRoleWithName:@"Echo"];
    
    NSArray* newDistribution = [groupModel decide];
    
    NSLog(@"%@",newDistribution);
    
    
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

@end
