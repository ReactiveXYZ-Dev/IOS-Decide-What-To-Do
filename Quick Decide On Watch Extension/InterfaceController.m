//
//  InterfaceController.m
//  Quick Decide On Watch Extension
//
//  Created by Jackie Chung on 19/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "InterfaceController.h"

#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceController()<WCSessionDelegate>


@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *wkDecideBtn;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *wkResultLabel;

@end


@implementation InterfaceController

#pragma mark - Life Cycles
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    if ([WCSession isSupported]) {
        
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        
    }
    
}


- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - Actions
- (IBAction)quickDecide {
    
    // prepare data
    NSDictionary* data = @{
                    @"action":@"quick_decide"
                           };
    // send message to iphone and check reply
    [[WCSession defaultSession]sendMessage:data replyHandler:^(NSDictionary* reply){
        
        NSString* result = [reply objectForKey:@"response"];
        
        [self animateWithDuration:1.5 animations:^(void){
           
            [_wkResultLabel setAlpha:0];
            
            [_wkResultLabel setText:result];
            
            
        }];
        
        
        [_wkResultLabel setAlpha:1];

        
        
    } errorHandler:^(NSError* error){
        
        WKAlertAction* dismissBtn = [WKAlertAction actionWithTitle:@"Okay" style:WKAlertActionStyleDefault handler:^(void){
            
        }];
        
        [self presentAlertControllerWithTitle:@"Error" message:@"Please check if your device is paired" preferredStyle:WKAlertControllerStyleAlert actions:@[dismissBtn]];
        
    }];
}

#pragma mark - Private methods


@end



