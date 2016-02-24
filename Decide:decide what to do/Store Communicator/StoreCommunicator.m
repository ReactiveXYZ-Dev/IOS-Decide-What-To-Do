//
//  StoreCommunicator.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 12/02/2016.
//  Copyright © 2016 Future Innovation Studio. All rights reserved.
//

#import "StoreCommunicator.h"

#import "MBProgressHUD.h"

@interface StoreCommunicator()

@end

@implementation StoreCommunicator

+(instancetype)sharedCommunicator{
    
    static StoreCommunicator* communicator = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^(void){
       
        communicator = [[self alloc]init];
        
    });
    
    return communicator;
    
}


-(void)buyUpgradeWithSuccessHandler:(void (^)(SKPaymentTransaction* transaction))success andFailureHandler:(void (^)(NSError *))failure{
    
    // present an HUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication]delegate]window] animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.label.text = NSLocalizedString(@"Putting your VIP in the basket...", @"HUD requesting IAP product");
    
    // Configure the button.
    [hud.button setTitle:NSLocalizedString(@"Dismiss", @"HUD cancel button title") forState:UIControlStateNormal];
    
    [hud.button addTarget:self action:@selector(dismissHUD) forControlEvents:UIControlEventTouchUpInside];

    // fetch upgrade
    [[RMStore defaultStore]addPayment:@"DECIDE_IAP_APPUPGRADE"
     
    success:^(SKPaymentTransaction* transaction){
        
        // successfully paid
        // hide hud
        [hud hideAnimated:YES];
        
        // send out success
        success(transaction);
        
        
    }
    failure:^(SKPaymentTransaction* transaction, NSError* error){
        
        // failed to pay
        // hide the hud
        [hud hideAnimated:YES];
        
        // send out failure
        failure(error);
        
    }];
    
}

-(void)restoreUpgradeWithSuccessHandler:(void (^)(NSArray *))success failureHandler:(void (^)(NSError *))failure{
    
    // present an HUD
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication]delegate]window] animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.label.text = NSLocalizedString(@"Putting your VIP in the basket...", @"HUD requesting IAP product");
    
    // Configure the button.
    [hud.button setTitle:NSLocalizedString(@"Dismiss", @"HUD cancel button title") forState:UIControlStateNormal];
    
    [hud.button addTarget:self action:@selector(dismissHUD) forControlEvents:UIControlEventTouchUpInside];
    
    // restore purchase
    [[RMStore defaultStore]restoreTransactionsOnSuccess:^(NSArray* transactions){
       
        // successfully restored
        // hide hud
        [hud hideAnimated:YES];
        
        // send out success msg
        success(transactions);
        
    }failure:^(NSError* error){
        
        // failed to restore
        // hide hud
        [hud hideAnimated:YES];
        
        // send out failure msg
        failure(error);
        
    }];
    
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

@end
