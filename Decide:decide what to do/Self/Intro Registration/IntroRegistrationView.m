//
//  IntroRegistrationView.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 9/02/2016.
//  Copyright © 2016 Future Innovation Studio. All rights reserved.
//

#import "IntroRegistrationView.h"

#import "DCFMTextField.h"

#import "APICommunicator.h"

#import "Helper.h"

#import "DCUserDefaultKeyConstants.h"

@interface IntroRegistrationView(){
    
    DCFMTextField* nameField;
    
    DCFMTextField* emailField;
    
}

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *noticeLabel;

@end

@implementation IntroRegistrationView

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self setUp];
        
    }
    
    return self;
}

// set up the view components
-(void)setUp{
    
    self.backgroundColor = [Helper colorFromHex:@"4bdaf4"];
    
    // create the intro labels
    _titleLabel = [[UILabel alloc]init];
    
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_titleLabel setTextColor:[UIColor whiteColor]];
    
    [_titleLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:24]];
    
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _titleLabel.text = @"Register Your Passion!";
    
    [self addSubview:_titleLabel];
    
    _noticeLabel = [[UILabel alloc]init];
    
    [_noticeLabel setTextColor:[UIColor whiteColor]];
    
    _noticeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _noticeLabel.textAlignment = NSTextAlignmentCenter;
    
    _noticeLabel.numberOfLines = 5;
    
    _noticeLabel.text = @"After registration, you are able to: \n - View global stats \n - View your contribution to the global data! \n (How cool is that !)";
    
    [_noticeLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:14]];
    
    [self addSubview:_noticeLabel];
    
    // create the user name textfield
    nameField = [[DCFMTextField alloc]initWithRound:YES tintHex:nil placeholder:@"Type your name here"];
    
    nameField.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:nameField];
    
    // create the user email textfield
    emailField = [[DCFMTextField alloc]initWithRound:YES tintHex:nil placeholder:@"Type your email here"];
    
    emailField.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:emailField];
    
    // create the register button
    UIButton* registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    registerButton.tintColor = [UIColor whiteColor];
    
    [registerButton setTitle:@"Register" forState:UIControlStateNormal];
    
    [registerButton addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    
    registerButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:registerButton];
    
    // create the signin button
    UIButton* signInButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    signInButton.tintColor = [UIColor whiteColor];
    
    [signInButton setTitle:@"Sign in" forState:UIControlStateNormal];
    
    [signInButton addTarget:self action:@selector(signInUser) forControlEvents:UIControlEventTouchUpInside];
    
    signInButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:signInButton];
    
    // add constraints
    NSDictionary* views = NSDictionaryOfVariableBindings(_titleLabel,_noticeLabel,nameField,emailField,registerButton,signInButton);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[_titleLabel(==50)]-(30)-[_noticeLabel(==70)]-(40)-[nameField(==60)]-(20)-[emailField(==60)]-(230)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[nameField]-(30)-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[emailField]-(30)-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[emailField]-(30)-[registerButton]-(30)-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[emailField]-(30)-[signInButton]-(30)-|" options:NSLayoutFormatAlignAllRight metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(70)-[registerButton(==90)]-(50)-[signInButton(==90)]-(70)-|" options:0 metrics:nil views:views]];
    
    
}

#pragma mark - Actions
-(void)registerUser{
    
    if ([emailField isEmpty] || [nameField isEmpty]) {
        
        // check if there are any empty input
        [Helper showAlertWithTitle:@"Details not filled correctly" Message:@"Please check your input" CancelButtonTitle:@"Okay"];
        
    }else{
        
        // save credentials        
        [Helper setUserDefault:kUSER_NAME_KEY WithObject:[nameField retrieveInput]];
        
        [Helper setUserDefault:kUSER_EMAIL_KEY WithObject:[emailField retrieveInput]];
        
        // try registering
        [[APICommunicator sharedCommunicator]sendRemoteUserRequest:USER_REGISTER CompletionHandler:^(NSDictionary* result){
           
            if ([result[@"status"] isEqualToString:@"success"]) {
                
                // successfully registered
                [Helper showAlertWithTitle:@"Successfully registered" Message:result[@"message"] CancelButtonTitle:@"Great"];
                
                // set signed in user default
                [Helper setUserDefault:kUSER_IS_LOGGED_IN_KEY WithObject:@"yes"];
                
                
            }else{
                
                // fail to register
                [Helper removeUserCredentials];
                
                [Helper showAlertWithTitle:@"Fail to register" Message:result[@"message"] CancelButtonTitle:@"I will try later"];
                
                // set signed in user default
                [Helper setUserDefault:kUSER_IS_LOGGED_IN_KEY WithObject:@"yes"];
                
            }
            
            
        }];
        
        
    }
    
    
}

-(void)signInUser{
    
    if ([emailField isEmpty] || [nameField isEmpty]) {
        
        // check if there are any empty input
        [Helper showAlertWithTitle:@"Details not filled correctly" Message:@"Please check your input" CancelButtonTitle:@"Okay"];
        
    }else{
        
        // save credentials
        [Helper setUserDefault:kUSER_NAME_KEY WithObject:[nameField retrieveInput]];
        
        [Helper setUserDefault:kUSER_EMAIL_KEY WithObject:[emailField retrieveInput]];
        
        // try signing in
        [[APICommunicator sharedCommunicator]sendRemoteUserRequest:USER_LOGIN CompletionHandler:^(NSDictionary* result){
            
            if ([result[@"status"] isEqualToString:@"success"]) {
                
                // successfully signed in
                [Helper showAlertWithTitle:@"Successfully signed in" Message:result[@"message"] CancelButtonTitle:@"Great"];
                
                // set signed in user default
                [Helper setUserDefault:kUSER_IS_LOGGED_IN_KEY WithObject:@"yes"];
                
            }else{
                
                // fail to sign in
                [Helper removeUserCredentials];
                
                [Helper showAlertWithTitle:@"Fail to sign in" Message:result[@"message"] CancelButtonTitle:@"I will try later"];
                
                // set signed in user default
                [Helper setUserDefault:kUSER_IS_LOGGED_IN_KEY WithObject:@"no"];
                
            }
            
            
        }];
        
        
    }

    
}

@end
