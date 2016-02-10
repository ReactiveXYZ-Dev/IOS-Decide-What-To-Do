//
//  APICommunicator.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 2/01/2016.
//  Copyright © 2016 Future Innovation Studio. All rights reserved.
//

#import "APICommunicator.h"

#import <UIKit/UIKit.h>

#import "Helper.h"

#import "DCUserDefaultKeyConstants.h"

#import "MBProgressHUD.h"

#import "Reachability.h"

static const NSString* domain = @"http://decidewhattodoapi.dev/";

static const NSString* domainLocal = @"www.decidewhattodo.mobi";

static const NSString* baseUrl = @"api/v1";

@interface APICommunicator (){
    
    NSString* requestBaseUrl;
}

@end

@implementation APICommunicator

+(instancetype)sharedCommunicator{
    
    static APICommunicator* communicator = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^(void){
       
        communicator = [[self alloc]init];
        
    });
    
    return communicator;
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        // set base url
        requestBaseUrl = [NSString stringWithFormat:@"%@%@",domain,baseUrl];
        
    }
    
    return self;
    
}

#pragma mark - Accessors
-(NSString*)getRequestURLWithHTTP:(BOOL)withHTTP{
    
    return withHTTP?requestBaseUrl:domainLocal;
    
}

#pragma mark - Requests
-(void)sendRemoteCounterRequest:(REMOTE_COUNTER_REQUEST)type CompletionHanlder:(void (^)(NSDictionary *))completion{
    
    NSMutableDictionary<NSString*,NSString*>* actions = [[NSMutableDictionary alloc]init];
    
    // check types
    switch (type) {
            
        case COUNTER_ADD_LIKES:
            
            actions[@"method"] = @"post";
            
            actions[@"url"] = @"like";
            
            break;
        
        case COUNTER_ADD_FAILURE_COUNT:
            
            actions[@"method"] = @"post";
            
            actions[@"url"] = @"failure";
            
            break;
            
        case COUNTER_ADD_SUCCESS_COUNT:
            
            actions[@"method"] = @"post";
            
            actions[@"url"] = @"success";
            
            break;
            
        case COUNTER_ADD_TOTAL_COUNT:
            
            actions[@"method"] = @"post";
            
            actions[@"url"] = @"counts";
            
            break;
            
        case COUNTER_FETCH_LIKE_COUNTS:
            
            actions[@"method"] = @"get";
            
            actions[@"url"] = @"like";
            
            break;
        case COUNTER_FETCH_SUCCESS_COUNTS:
            
            actions[@"method"] = @"get";
            
            actions[@"url"] = @"success";
            
            break;
            
        case COUNTER_FETCH_FAILURE_COUNTS:
            
            actions[@"method"] = @"get";
            
            actions[@"url"] = @"failure";
            
            break;
        
        case COUNTER_FETCH_TOTAL_COUNTS:
            
            actions[@"method"] = @"get";
            
            actions[@"url"] = @"counts";
            
            break;
        
        default:
            
            break;
    }
    
    
    // set the relative url
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/counter/%@",requestBaseUrl,actions[@"url"]]];
    
    // send the request
    [self makeRequestToUrl:requestURL requestMethod:actions[@"method"] Data:nil connectionErrorMessage:@"Sorry. Network Error." jsonErrorMessage:@"Sorry. Parse Error." CompletionHandler:completion];
    
}

-(void)sendRemoteUserRequest:(REMOTE_USER_REQUEST)type CompletionHandler:(void (^)(NSDictionary *))completion{
    
    NSMutableDictionary<NSString*,NSString*>* actions = [[NSMutableDictionary alloc]init];
    
    switch (type) {
            
        case USER_REGISTER:
            
            actions[@"method"] = @"post";
            
            actions[@"url"] = @"register";
            
            actions[@"data"] = [NSString stringWithFormat:@"name=%@&email=%@",[Helper getObjectFromUserDefaultWithName:kUSER_NAME_KEY],[Helper getObjectFromUserDefaultWithName:kUSER_EMAIL_KEY]];
            
            break;
        
        case USER_LOGIN:
            
            actions[@"method"] = @"post";
            
            actions[@"url"] = @"login";
            
            actions[@"data"] = [NSString stringWithFormat:@"name=%@&email=%@",[Helper getObjectFromUserDefaultWithName:kUSER_NAME_KEY],[Helper getObjectFromUserDefaultWithName:kUSER_EMAIL_KEY]];
            
            break;
        
        case USER_GET_DECISION_COUNT:
            
            actions[@"method"] = @"get";
            
            actions[@"url"] = [NSString stringWithFormat:@"decision-count/%@/%@",[Helper getObjectFromUserDefaultWithName:kUSER_NAME_KEY],[Helper getObjectFromUserDefaultWithName:kUSER_EMAIL_KEY]];
            
            break;
            
        case USER_INCREMENT_DECISION_COUNT:
            
            actions[@"method"] = @"post";
            
            actions[@"url"] = [NSString stringWithFormat:@"decision-count/%@/%@/1",[Helper getObjectFromUserDefaultWithName:kUSER_NAME_KEY],[Helper getObjectFromUserDefaultWithName:kUSER_EMAIL_KEY]];
            
        default:
            
            break;
            
    }
    
    // set the request url
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/auth/%@",requestBaseUrl,actions[@"url"]]];
    
    // send the request
    [self makeRequestToUrl:requestURL requestMethod:actions[@"method"] Data:actions[@"data"] connectionErrorMessage:@"Sorry. There seem to be some connection problems. Please try later" jsonErrorMessage:@"Sorry. The data cannot be parsed. Please try later" CompletionHandler:completion];
    
}

// the main request method stub
-(void)makeRequestToUrl:(NSURL*)url requestMethod:(NSString*)method Data:(NSString*)data connectionErrorMessage:(NSString*)connErrorMessage jsonErrorMessage:(NSString*)jsonErrorMessage CompletionHandler:(void (^)(NSDictionary *))completion{
    
    if (_reachability_status == API_UNKNOWN) {
        
        [Helper showAlertWithTitle:@"Connecting to remote service..." Message:@"Don't worry, it shall be done soon. So be happy!" CancelButtonTitle:@"I will be happy"];
        
        completion(nil);
        
    }else if (_reachability_status == API_UNREACHABLE){
    
        [Helper showAlertWithTitle:@"Network available" Message:@"Sorry. Something goes wrong on the web. Please try again later" CancelButtonTitle:@"Okay"];
        
        if (completion) {
            
            completion(nil);
            
        }
        
    }else{
        
        // set url request
        NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
        
        [urlRequest setHTTPMethod:method];
        
        if (data != nil) {
            
            [urlRequest setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        
        // show hud
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication]delegate]window] animated:YES];
        
        // Set the determinate mode to show task progress.
        hud.mode = MBProgressHUDModeIndeterminate;
        
        hud.label.text = NSLocalizedString(@"Getting things done..", @"HUD loading title in api");
        
        // Configure the button.
        [hud.button setTitle:NSLocalizedString(@"Dismiss", @"HUD cancel button title") forState:UIControlStateNormal];
        
        [hud.button addTarget:self action:@selector(dismissHUD) forControlEvents:UIControlEventTouchUpInside];
        
        // create result data
        __block NSDictionary* outcome;
        
        // send the request
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
            
            if (connectionError) {
                
                [Helper showAlertWithTitle:@"Connection Error!" Message:connErrorMessage CancelButtonTitle:@"Okay"];
                
                outcome = nil;
                
            }else{
                
                NSError* error;
                
                NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                
                if (!jsonResponse) {
                    
                    [Helper showAlertWithTitle:@"Parse Error!" Message:jsonErrorMessage CancelButtonTitle:@"Okay"];
                    
                    outcome = nil;
                    
                }else{
                    
                    outcome = jsonResponse;
                    
                }
                
            }
            // hide hud
            [hud hideAnimated:YES];
            
            // send data back to completion handler
            if (completion) {
                
                completion(outcome);
                
            }
            
        }];

        
    }
    
}

#pragma mark - Other actions
-(void)dismissHUD{
    
    // dismiss HUD
    [[MBProgressHUD HUDForView:[[[UIApplication sharedApplication]delegate]window]] hideAnimated:YES];
    
    // show an extra layer of notice that the process still runs in background
    MBProgressHUD* toast = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication]delegate]window] animated:YES];
    
    toast.mode = MBProgressHUDModeText;
    
    toast.label.text = @"Process runs in background...";
    
    toast.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [toast hideAnimated:YES afterDelay:1.0];
    
}

-(BOOL)isReachable{
    
    return _reachability_status == API_REACHABLE?YES:NO;
    
}

@end
