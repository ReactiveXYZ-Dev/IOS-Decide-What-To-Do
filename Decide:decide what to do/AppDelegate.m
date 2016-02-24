//
//  AppDelegate.m
//  Decide:decide what to do
//
//  Created by YINGGUANG CHEN on 4/10/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "AppDelegate.h"

#import "QuickDecideViewController.h"

#import "DCUserDefaultKeyConstants.h"

#import "Helper.h"

#import "APICommunicator.h"

#import "Reachability.h"

#import "EAIntroView.h"

#import "ViewComposer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Helper setUserDefault:kUSER_HAS_PURCHASED_ADDON WithObject:@(YES)];
    // check API reachability
    [[APICommunicator sharedCommunicator] setReachability_status:API_UNKNOWN];
    
    if ([Helper localUserExists]) {
        
        NSLog(@"loggin??");
        
        Reachability* apiChecker = [Reachability reachabilityWithHostName:[[APICommunicator sharedCommunicator]getRequestURLWithHTTP:NO]];
        
        // reachable -> background load
        apiChecker.reachableBlock = ^(Reachability* reach){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"REACHABLE!");
                
                // set status flag
                [[APICommunicator sharedCommunicator]setReachability_status:API_REACHABLE];
                
                // check if logged in
                [[APICommunicator sharedCommunicator]sendRemoteUserRequest:USER_LOGIN CompletionHandler:^(NSDictionary* result){
                    
                    if ([result[@"status"] isEqualToString:@"success"]) {
                        
                        // login successfully
                        NSLog(@"loggedin");
                        
                        // set signed in to be true
                        [Helper setUserDefault:kUSER_IS_LOGGED_IN_KEY WithObject:@"yes"];
                        
                        
                    }else{
                        
                        // login failure
                        NSLog(@"try logging but failed");
                        
                        // set signed in to be false
                        [Helper setUserDefault:kUSER_IS_LOGGED_IN_KEY WithObject:@"no"];
                        
                    }
                    
                }];

                
            });
            
            
        };
        
        // unreachable -> background load
        apiChecker.unreachableBlock = ^(Reachability* reach){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"UNREACHABLE!");
                
                // set status flag
                [[APICommunicator sharedCommunicator]setReachability_status:API_UNREACHABLE];
                
            });
            
            
        
        };
        
        [apiChecker startNotifier];

    }else{
        
        NSLog(@"local user not exist");
        
        // set signed in to be false
        [Helper setUserDefault:kUSER_IS_LOGGED_IN_KEY WithObject:@"no"];
        
        // check reachability
        Reachability* apiChecker = [Reachability reachabilityWithHostName:[[APICommunicator sharedCommunicator]getRequestURLWithHTTP:NO]];
        
        apiChecker.reachableBlock = ^(Reachability* reach){
          
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"REACHABLE!");
                
                // set status flag
                [[APICommunicator sharedCommunicator]setReachability_status:API_REACHABLE];
                
            });

            
        };
        
        
        apiChecker.unreachableBlock = ^(Reachability* reach){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"UNREACHABLE!");
                
                // set status flag
                [[APICommunicator sharedCommunicator]setReachability_status:API_UNREACHABLE];
                
            });

            
        };
        
        [apiChecker startNotifier];
        
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
    
    if ([Helper localUserExists]) {
       
        [[APICommunicator sharedCommunicator]sendRemoteUserRequest:USER_GET_DECISION_COUNT CompletionHandler:^(NSDictionary* result){
            
            if ([result[@"status"] isEqualToString:@"success"]) {
                
                [Helper setUserDefault:kUSER_COUNT_KEY WithObject:(NSNumber*)result[@"message"]];
                
            }else{
                
                NSLog(@"Cannot retrieve data");
            }
            
        }];
        
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

// 3DTouch
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    if ([shortcutItem.type isEqualToString:@"net.fistudio.decide-what-to-do.quickdecide"]) {
        
        // quick decide shortcut
        [[NSNotificationCenter defaultCenter]postNotificationName:kQD_3D_TOUCH_RECEIVER_KEY object:nil];
        
    }
    
}

@end
