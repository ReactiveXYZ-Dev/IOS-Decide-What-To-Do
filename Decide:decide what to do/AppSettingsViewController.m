//
//  AppSettingsViewController.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 31/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//
#import <MessageUI/MessageUI.h>

#import "AppSettingsViewController.h"

#import "UIColor+Bohr.h"

#import "DCUserDefaultKeyConstants.h"

#import "APICommunicator.h"

#import "Helper.h"

#import "ViewComposer.h"

@interface AppSettingsViewController ()<MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>

@end

@implementation AppSettingsViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self decorate];
    
    [self setUpComponents];
}


-(void)decorate{
    
    UIColor *color = [UIColor bo_blueColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
}

-(void)setUpComponents{
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    // User section
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"Account" handler:^(BOTableViewSection* section){
        
        // user name textfield
        [section addCell:[BOTextTableViewCell cellWithTitle:@"Your Name:" key:kUSER_NAME_KEY handler:^(BOTextTableViewCell* sender){
            
            sender.textField.placeholder = @"Please enter here";
            
        }]];
        
        // user email textfield
        [section addCell:[BOTextTableViewCell cellWithTitle:@"Your Email:" key:kUSER_EMAIL_KEY handler:^(BOTextTableViewCell* sender){
            
            sender.textField.placeholder = @"Please enter here";
            
        }]];
        
        // user actionable button
        NSString* cellTitle = [[NSString alloc]init];
        
        if ([Helper localUserExists] == NO) {
            
            // user not even registered -> register button
            cellTitle = @"Register / Sign in";
            
            
        }else if([Helper userLoggedin] == NO){
            
            // user not logged in -> sign in button
            cellTitle = @"Sign in now!";
            
        }else{
            
            // user exists and is signed in
            cellTitle = @"Check out your global stats!";
        }
        
        [section addCell:[BOButtonTableViewCell cellWithTitle:cellTitle key:nil handler:^(BOButtonTableViewCell* sender){
            
            
            if ([Helper localUserExists] == NO) {

                // user not even registered -> register button
                sender.actionBlock = ^{
                    
                    [weakSelf registerUser];
                    
                };
                
                
            }else if([Helper userLoggedin] == NO){
                
                // user not logged in -> sign in button
                sender.actionBlock = ^{
                
                    [weakSelf signInUser];
                    
                };
                
                
            }else{
                
                // user exists and is signed in
                sender.actionBlock = ^{
                    
                    [weakSelf presentUserGlobalRank];
                    
                };
                
            }

        }]];
        
        
    }]];
    
    // General section
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"General" handler:^(BOTableViewSection *section) {
        
        // show tutorial button
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"Show tutorial" key:nil handler:^(BOButtonTableViewCell* sender){
            
            sender.actionBlock = ^{
              
                [[[ViewComposer sharedComposer] appTutorialViews] showInView:self.navigationController.view animateDuration:0.65];
                
            };
        }]];
        
        // spread it out button
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"Spread it out" key:nil handler:^(BOButtonTableViewCell* sender){
            
            sender.actionBlock = ^(void){
                
                //@todo: the stuff to share
                NSString* ad = @"I am using this cool app!";
                
                // present the vc
                [weakSelf presentActivityViewControllerWithShareItems:@[ad] excludedActivityTypes:nil];

            };
            
        }]];
    
    }]];
    
    // Support us section
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"Support us" handler:^(BOTableViewSection *section) {
        
        // upgrade (in app purchase) button
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"Buy us a cup of coffee $0.99" key:nil handler:^(BOButtonTableViewCell* sender){
            
            //...
            
        }]];
        
        // restore purchase button
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"Restore purchases" key:nil handler:^(BOButtonTableViewCell* sender){
            
            //...
            
        }]];
        
        // View pro benefits
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"View benefits" key:nil handler:^(BOButtonTableViewCell* sender){
            
            sender.actionBlock = ^(void){
                
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"What you will get" message:@"- You can assign multiple VIP privileges to one participant \n - You can view more cool global stats \n- Our team can have a happier life :)" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                
                [alertView show];
                
            };
            
        }]];

    }]];
    
    // Question section
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"Question" handler:^(BOTableViewSection* section){
        
        // contact us (email)
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"Contact us" key:nil handler:^(BOButtonTableViewCell* sender){
            
            sender.actionBlock = ^(void){
                
                // @weird: mail composer crashed outside of the simulator's context?
                BOOL success = [weakSelf composeMailSenderToEmail:kSERVICE_EMAIL withContents:@"Please write your feed back below:"];
                
                if (!success) {
                    
                    [[[UIAlertView alloc]initWithTitle:@"Sent failure" message:@"Please try later!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil] show];
                    
                }

                
            };
            
        }]];
        
        // view our website
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"View our website" key:nil handler:^(BOButtonTableViewCell* sender){
            
            // open safari for website
            sender.actionBlock = ^(void){
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.fistudio.net"]];
                
            };
            
            
        }]];
        
        // add footer
        section.footerTitle = @"Copyright FIStudio (a.k.a Reactive Studio).";
        
    }]];

    
}

#pragma mark - Actions

// dismiss the view controller and complete some actions
- (IBAction)dismissModal:(id)sender {
    
    NSLog(@"%@,%@,%@",[Helper getObjectFromUserDefaultWithName:kUSER_NAME_KEY],[Helper getObjectFromUserDefaultWithName:kUSER_EMAIL_KEY],[Helper getObjectFromUserDefaultWithName:kUSER_IS_LOGGED_IN_KEY]);
    
    __weak AppSettingsViewController* weakSelf = self;
    
    [weakSelf dismissViewControllerAnimated:YES completion:nil];
    
}

// send mail
-(BOOL)composeMailSenderToEmail:(NSString *)recipient withContents:(NSString *)content{
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc]init];
        
        mailController.delegate = self;
        
        [mailController setSubject:@"Request from App"];
        
        [mailController setMessageBody:content isHTML:NO];
        
        [mailController setToRecipients:@[recipient]];
        
        if ([self isKindOfClass:[UIViewController class]]) {
            
            [self presentViewController:mailController animated:YES completion:nil];
            
            return YES;
            
        }
        
        return NO;
        
    }
    
    return NO;
    
}

// mail delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)presentActivityViewControllerWithShareItems:(NSArray *)items excludedActivityTypes:(NSArray *)excludedTypes{
    
    UIActivityViewController* activityController = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    activityController.excludedActivityTypes = excludedTypes;
    
    [self presentViewController:activityController animated:YES completion:nil];
    
}

-(void)presentUserGlobalRank{
    
    [Helper userDecisionCountsWithCompletionHandler:^(NSInteger userDecisionCount){
       
        [Helper totalDecisionCountsWithCompletionHandler:^(NSInteger totalDecisionCount){
           
            NSString* alertText = [NSString stringWithFormat:@"You've made %li decisions out of %li in total",userDecisionCount,totalDecisionCount];
            
            [[[UIAlertView alloc]initWithTitle:@"Where you are from bird-eye" message:alertText delegate:self cancelButtonTitle:@"Cool" otherButtonTitles:nil, nil] show];
            
        }];
        
    }];
    
}

-(void)registerUser{
    
    NSLog(@"Registering??");
    
    if (![Helper localUserExists]) {
        
        // try registering the user
        [[APICommunicator sharedCommunicator]sendRemoteUserRequest:USER_REGISTER CompletionHandler:^(NSDictionary* result){
            
            // check response
            if ([result[@"status"] isEqualToString:@"success"]) {
                NSLog(@"%@",result[@"message"]);
                // show the alert
                [Helper showAlertWithTitle:@"Successfully registered!" Message:result[@"message"] CancelButtonTitle:@"okay"];
                
                // set islogin default to be true
                [Helper setUserDefault:kUSER_IS_LOGGED_IN_KEY WithObject:@"yes"];
                
                NSLog(@"re success: %@",result[@"message"]);
                
            }else{
                
                // show error
                [Helper showAlertWithTitle:@"Failed to register! Please try again later" Message:result[@"message"] CancelButtonTitle:@"okay"];
                
                // remove input credentials
                [Helper removeUserCredentials];
                
            }
            
        }];

        
    }else{
        
        [Helper showAlertWithTitle:@"Fields has not been filled!" Message:@"Please fill your name and email completely" CancelButtonTitle:@"Okay"];
        
    }
    
    
}

-(void)signInUser{
    
    NSLog(@"signing in??");
    
    // try signing in the user
    [[APICommunicator sharedCommunicator]sendRemoteUserRequest:USER_LOGIN CompletionHandler:^(NSDictionary* result){
       
        // check response
        if ([result[@"status"] isEqual:@"success"]) {
                        
            // show the alert
            [Helper showAlertWithTitle:@"Successfully signed in!" Message:result[@"message"] CancelButtonTitle:@"okay"];
            
            // set islogin default to be true
            [Helper setUserDefault:kUSER_IS_LOGGED_IN_KEY WithObject:@"yes"];
            
            NSLog(@"sign success: %@",result[@"message"]);
            
        }else{
            
            // show error
            [Helper showAlertWithTitle:@"Failed to sign in. Please try again later!" Message:result[@"message"] CancelButtonTitle:@"okay"];
            
            // remove user credentials
            [Helper removeUserCredentials];
        }
        
    }];
    
}

@end
