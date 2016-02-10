//
//  Helper.h
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 3/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface Helper : NSObject

+(NSString*)stringWithInteger:(NSInteger)integer;

+(NSString*)stringDescribingCGRect:(CGRect)rect;

+(void)nslog:(NSString*)string;

+(void)nslogFrame:(CGRect)frame;

+(UIImage*)resizeImageWithSourceName:(NSString*)imageName AndScale:(float)scale;

+(UIColor*)colorFromHex:(NSString*)hex;

+(BOOL)is:(int)number inRangeBetween:(int)a and:(int)b;

+(void)setUserDefault:(NSString*)name WithObject:(id)object;

+(id)getObjectFromUserDefaultWithName:(NSString*)name;

+(void)removeObjectFromUserDefaultWithName:(NSString*)name;

+(void)showAlertWithTitle:(NSString*)title Message:(NSString*)message CancelButtonTitle:(NSString*)btnTitle;

+(void)showErrorAlert;

// Options checking
+(BOOL)hasShownWalkthrough;

+(BOOL)localUserExists;

+(BOOL)userLoggedin;

+(BOOL)userHasPurchased;

+(void)removeUserCredentials;

+(void)incrementDecisionCount;

+(void)incrementSuccessWithCompletionHandler:(void (^)(BOOL))completion;

+(void)incrementFailureWithCompletionHandler:(void (^)(BOOL))completion;

+(void)incrementLikeWithCompletionHandler:(void (^)(BOOL))completion;

+(void)userDecisionCountsWithCompletionHandler:(void (^)(NSInteger))completion;

+(void)totalDecisionCountsWithCompletionHandler:(void (^)(NSInteger))completion;

@end
