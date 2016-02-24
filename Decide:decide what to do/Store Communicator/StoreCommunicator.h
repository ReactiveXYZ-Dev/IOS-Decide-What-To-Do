//
//  StoreCommunicator.h
//  Decide:decide what to do
//
//  Created by Jackie Chung on 12/02/2016.
//  Copyright © 2016 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMStore.h"


@interface StoreCommunicator : NSObject

@property (assign,nonatomic) BOOL productFetchable;

+(instancetype)sharedCommunicator;

-(void)buyUpgradeWithSuccessHandler:(void(^)(SKPaymentTransaction* transaction))success andFailureHandler:(void(^)(NSError* error))failure;

-(void)restoreUpgradeWithSuccessHandler:(void ( ^ ) ( NSArray *transactions ))success failureHandler:(void ( ^ ) ( NSError *error ))failure;

@end
