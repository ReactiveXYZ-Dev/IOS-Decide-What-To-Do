//
//  APICommunicator.h
//  Decide:decide what to do
//
//  Created by Jackie Chung on 2/01/2016.
//  Copyright © 2016 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,REMOTE_COUNTER_REQUEST) {
    
    COUNTER_ADD_LIKES = 0,
    COUNTER_ADD_SUCCESS_COUNT,
    COUNTER_ADD_FAILURE_COUNT,
    COUNTER_ADD_TOTAL_COUNT,
    COUNTER_FETCH_LIKE_COUNTS,
    COUNTER_FETCH_SUCCESS_COUNTS,
    COUNTER_FETCH_FAILURE_COUNTS,
    COUNTER_FETCH_TOTAL_COUNTS
};

typedef NS_ENUM(NSInteger,REMOTE_USER_REQUEST) {
    
    USER_REGISTER = 0,
    USER_LOGIN,
    USER_GET_DECISION_COUNT,
    USER_INCREMENT_DECISION_COUNT
    
};

typedef NS_ENUM(NSInteger, API_REACHABILITY) {
    
    API_UNKNOWN = 0,
    API_UNREACHABLE,
    API_REACHABLE
    
};

@interface APICommunicator : NSObject

+(instancetype)sharedCommunicator;

/**
 
 * @brief   Send request to manipulate data in the remote global counter
 
 * @param   Request type, CompletionHandler completion
 
 * @return  void
 
 */
-(void)sendRemoteCounterRequest:(REMOTE_COUNTER_REQUEST)type CompletionHanlder:(void(^)(NSDictionary*))completion;

/**
 
 * @brief   Send request to manipulate data in the remote user database
 
 * @param   Request type, CompletionHandler completion
 
 * @return  void
 
 */
-(void)sendRemoteUserRequest:(REMOTE_USER_REQUEST)type CompletionHandler:(void(^)(NSDictionary*))completion;

/**
 
 * @brief   Get the global request url
 
 */
-(NSString*)getReachabilityUrl;

/**
 
 * @brief   Return whether the api is reachable or not
 
 */
-(BOOL)isReachable;

/**
 
 * @brief   API Reachability indicator
 
 */
@property (assign,nonatomic) API_REACHABILITY reachability_status;

@end
