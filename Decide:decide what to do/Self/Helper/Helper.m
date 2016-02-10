//
//  Helper.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 3/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "Helper.h"

#import "DCForMeObject.h"

#import "DCUserDefaultKeyConstants.h"

#import "APICommunicator.h"

@implementation Helper

+(NSString*)stringWithInteger:(NSInteger)integer{
    
    return [NSString stringWithFormat:@"%li",(long)integer];
 
}

+(NSString*)stringDescribingCGRect:(CGRect)rect{
    
    return NSStringFromCGRect(rect);
    
}


+(void)nslog:(NSObject *)object{
    
    NSLog(@"%@",object);
    
}

+(void)nslogFrame:(CGRect)frame{
    
    NSLog(@"origin x: %f, y: %f. Size width: %f, height: %f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    
}


+(UIImage*)resizeImageWithSourceName:(NSString *)imageName AndScale:(float)scale{
    
    return [UIImage imageWithCGImage:[UIImage imageNamed:imageName].CGImage scale:scale orientation:UIImageOrientationUp];
    
}

+(UIColor*)colorFromHex:(NSString *)hex{
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];

    
}

+(BOOL)is:(int)number inRangeBetween:(int)a and:(int)b{
    
    if (number >= a && number < b) {
        
        return true;
        
    }
    
    return false;
}

+(void)setUserDefault:(NSString *)name WithObject:(id)object{
    
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:name];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(id)getObjectFromUserDefaultWithName:(NSString *)name{
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:name];
    
}

+(void)removeObjectFromUserDefaultWithName:(NSString *)name{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:name];
    
}

+(void)incrementDecisionCount{
    
    // check if user exist
    if ([self localUserExists] && ([[APICommunicator sharedCommunicator]reachability_status] == API_REACHABLE)) {
        
        // increment for each user
        [[APICommunicator sharedCommunicator]sendRemoteUserRequest:USER_INCREMENT_DECISION_COUNT CompletionHandler:^(NSDictionary* result){
            
            NSLog(@"%@",result);
            
        }];
        
    }
    
    
    
    // increment global counter
    [[APICommunicator sharedCommunicator]sendRemoteCounterRequest:COUNTER_ADD_TOTAL_COUNT CompletionHanlder:^(NSDictionary* result){
       
        NSLog(@"%@",result);
        
    }];
    
}


+(void)incrementSuccessWithCompletionHandler:(void (^)(BOOL))completion{
    
    __block BOOL toBeReturned;
    
    [[APICommunicator sharedCommunicator]sendRemoteCounterRequest:COUNTER_ADD_SUCCESS_COUNT CompletionHanlder:^(NSDictionary* result){
        
        if ([result[@"status"] isEqualToString:@"success"]) {
            
            toBeReturned = YES;
            
        }else{
            
            toBeReturned = NO;
        }
        
        if (completion) {
            
            completion(toBeReturned);
            
        }
        
    }];

    
}


+(void)incrementFailureWithCompletionHandler:(void (^)(BOOL))completion{
    
    __block BOOL toBeReturned;
    
    [[APICommunicator sharedCommunicator]sendRemoteCounterRequest:COUNTER_ADD_FAILURE_COUNT CompletionHanlder:^(NSDictionary* result){
                
        if ([result[@"status"] isEqualToString:@"success"]) {
            
            toBeReturned = YES;
            
        }else{
            
            toBeReturned = NO;
        }
        
        if (completion) {
            
            completion(toBeReturned);
            
        }
        
    }];
    
    
}

+(void)incrementLikeWithCompletionHandler:(void (^)(BOOL))completion{
    
    __block BOOL toBeReturned;
    
    [[APICommunicator sharedCommunicator]sendRemoteCounterRequest:COUNTER_ADD_LIKES CompletionHanlder:^(NSDictionary* result){
        
        if ([result[@"status"] isEqualToString:@"success"]) {
            
            toBeReturned = YES;
            
        }else{
            
            toBeReturned = NO;
        }
        
        if (completion) {
            
            completion(toBeReturned);
            
        }
        
    }];
    
}

+(BOOL)hasShownWalkthrough{
    
    if ([self getObjectFromUserDefaultWithName:kWALKTHROUGH_HAS_BEEN_DISPLAYED_KEY] && [[self getObjectFromUserDefaultWithName:kWALKTHROUGH_HAS_BEEN_DISPLAYED_KEY] isEqualToString:@"yes"]) {
        
        return YES;
        
    }
    
    return NO;
    
}

+(BOOL)localUserExists{
    
    if ([Helper getObjectFromUserDefaultWithName:kUSER_NAME_KEY] && [Helper getObjectFromUserDefaultWithName:kUSER_EMAIL_KEY]) {
     
        return YES;
    }
    
    return NO;
}

+(BOOL)userLoggedin{
    
    if ([[Helper getObjectFromUserDefaultWithName:kUSER_IS_LOGGED_IN_KEY] isEqual:@"yes"]) {
        
        return YES;
        
    }
    
    return NO;
    
}

+(BOOL)userHasPurchased{
    
    if ([[Helper getObjectFromUserDefaultWithName:kUSER_HAS_PURCHASED_ADDON] isEqualToNumber:@(YES)]) {
                
        return YES;
        
    }
    
    return NO;
    
}

+(void)removeUserCredentials{
    
    [self removeObjectFromUserDefaultWithName:kUSER_NAME_KEY];
    
    [self removeObjectFromUserDefaultWithName:kUSER_EMAIL_KEY];
    
}

+(void)totalDecisionCountsWithCompletionHandler:(void (^)(NSInteger))completion{
    
    [[APICommunicator sharedCommunicator]sendRemoteCounterRequest:COUNTER_FETCH_TOTAL_COUNTS CompletionHanlder:^(NSDictionary* result){
        
        NSNumber* toBeReturned;
        
        if ([result[@"status"] isEqualToString:@"success"]) {
            
            toBeReturned = (NSNumber*)result[@"message"];
            
        }else{
            
            toBeReturned = nil;
        }
        
        if (toBeReturned) {
            
            if (completion) {
                
                completion([toBeReturned integerValue]);
                
            }
            
        }
        
    }];
    
}

+(void)userDecisionCountsWithCompletionHandler:(void (^)(NSInteger))completion{
    
    if ([self localUserExists] && ([[APICommunicator sharedCommunicator]reachability_status] == API_REACHABLE)) {
        
        [[APICommunicator sharedCommunicator]sendRemoteUserRequest:USER_GET_DECISION_COUNT CompletionHandler:^(NSDictionary* result){
            
            NSNumber* toBeReturned;
            
            if ([result[@"status"] isEqualToString:@"success"]) {
                
                toBeReturned = (NSNumber*)result[@"message"];
                
            }else{
                
                toBeReturned = nil;
            }
            
            if (toBeReturned) {
                
                if (completion) {
                    
                    completion([toBeReturned integerValue]);
                    
                }
                
            }
            
        }];
        
    }
    
}

+(void)showAlertWithTitle:(NSString *)title Message:(NSString *)message CancelButtonTitle:(NSString *)btnTitle{
    
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil, nil] show];
    
}

+(void)showErrorAlert{
    
    [self showAlertWithTitle:@"Error" Message:@"Sorry. Something just went wrong" CancelButtonTitle:@"Try again later"];
    
}

@end
