//
//  DCFMTextField.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 18/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DCFMTextField.h"

#import "UIView+QuickSizeFetcher.h"

#import "Helper.h"

@interface DCFMTextField ()<UITextFieldDelegate>

@property (assign,nonatomic,setter=setRoundness:) BOOL isRounded;

@property (strong,nonatomic,setter=setHexCode:) NSString* tintHexCode;

@property (strong,nonatomic, setter=setPlaceHolderText:)NSString* placeHolderText;

@property (strong,nonatomic) UILabel* placeHolder;

@property (strong,nonatomic) UITextField* mainTextField;

@end

@implementation DCFMTextField

-(instancetype)initWithFrame:(CGRect)frame Round:(BOOL)round tintHex:(NSString*)hex placeholder:(NSString*)text{
    
    if (self = [super initWithFrame:frame]) {
        
        _isRounded = round;
        
        _tintHexCode = hex;
        
        _placeHolderText = text;
        
        [self setUp];
        
    }
    
    return self;
    
}

-(instancetype)initWithRound:(BOOL)round tintHex:(NSString *)hex placeholder:(NSString *)text{
    
    if (self = [super init]) {
        
        _isRounded = round;
        
        _tintHexCode = hex;
        
        _placeHolderText = text;
        
        [self setUp];
        
    }
    
    return self;
}

-(void)setUp{
    
    // set border width
    self.layer.borderWidth = 2.0f;
    
    // set roundness
    if (_isRounded) {
        
        self.layer.cornerRadius = 10.0;
        
        self.layer.masksToBounds = YES;
        
    }
    
    // set tint color
    if (_tintHexCode != nil) {
        
        self.layer.borderColor = [Helper colorFromHex:_tintHexCode].CGColor;
        
    }else{
        
        _tintHexCode = @"#ffffff";
        
        self.layer.borderColor = [Helper colorFromHex:_tintHexCode].CGColor;
        
    }
    
    // add placeholder label
    _placeHolder = [[UILabel alloc]init];
    
    _placeHolder.textAlignment = NSTextAlignmentCenter;
    
    _placeHolder.translatesAutoresizingMaskIntoConstraints = NO;
    
    _placeHolder.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:18];
    
    if (_placeHolderText == nil) {
        
        _placeHolder.text = @"Enter here";
        
    }else{
        
        _placeHolder.text = _placeHolderText;
        
    }
    
    if (_tintHexCode == nil) {
        
        _placeHolder.textColor = [Helper colorFromHex:_tintHexCode];
        
    }else{
        
        _placeHolder.textColor = [Helper colorFromHex:@"#ffffff"];
        
    }
    
    [self addSubview:_placeHolder];
    
    // add transparent textfield
    _mainTextField = [[UITextField alloc]init];
    
    _mainTextField.borderStyle = UITextBorderStyleNone;
    
    _mainTextField.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18];
    
    _mainTextField.textColor = [Helper colorFromHex:_tintHexCode];
    
    _mainTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    _mainTextField.textAlignment = NSTextAlignmentCenter;
    
    _mainTextField.delegate = self;
    
    [_mainTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self insertSubview:_mainTextField aboveSubview:_placeHolder];
    
    // add constraints
    NSDictionary* views = NSDictionaryOfVariableBindings(_mainTextField,_placeHolder);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_mainTextField]-(0)-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_placeHolder]-(0)-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_mainTextField]-(0)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_placeHolder]-(20)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
}


#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    // clear out placeholder label
    [UIView animateWithDuration:0.35 animations:^(void){
       
        _placeHolder.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
    }completion:^(BOOL finished){
        
        _placeHolder.hidden = YES;
        
    }];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    // check if needs to bring back placeholder
    if ([textField.text isEqualToString:@""]) {
        
        [UIView animateWithDuration:0.35 animations:^(void){
            
            _placeHolder.hidden = NO;
            
            _placeHolder.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        }];
        
    }

    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // exit keyboard
    [_mainTextField resignFirstResponder];
    
    return YES;
    
}


#pragma mark - Custom setters
-(void)setRoundness:(BOOL)value{
    
    _isRounded = value;
    
    self.layer.cornerRadius = [self getBoundWidth] / 75;
    
    self.layer.masksToBounds = YES;
    
    [self setNeedsDisplay];
    
}

-(void)setHexCode:(NSString *)hex{
    
    _tintHexCode = hex;
    
    UIColor* tint = [Helper colorFromHex:hex];
    
    self.layer.borderColor = tint.CGColor;
    
    _placeHolder.textColor = tint;
    
    [self setNeedsDisplay];
}

-(void)setPlaceHolderText:(NSString *)text{
    
    _placeHolder.text = text;
    
    [self setNeedsDisplay];
    
}

#pragma mark - extension methods
-(NSString*)retrieveInput{
    
    return _mainTextField.text;
    
}

-(void)textFieldDidChange:(id)sender{
    
    [_delegate textFieldDidFinishEditingWithInput:[self retrieveInput]];
    
}

@end
