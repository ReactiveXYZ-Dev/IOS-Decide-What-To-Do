//
//  DCFMTextField.h
//  Decide:decide what to do
//
//  Created by Jackie Chung on 18/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DCFMTextFieldDelegate

@optional
-(void)textFieldDidFinishEditingWithInput:(NSString*)text;

@end

@interface DCFMTextField : UIView 

@property(nonatomic,assign) id<DCFMTextFieldDelegate> delegate;

// custom setters
-(void)setRoundness:(BOOL)value;

-(void)setHexCode:(NSString*)hex;

-(void)setPlaceHolderText:(NSString*)text;

// custom initializer (with frame)
-(instancetype)initWithFrame:(CGRect)frame Round:(BOOL)round tintHex:(NSString*)hex placeholder:(NSString*)text;

// custom initializer (without frame)
-(instancetype)initWithRound:(BOOL)round tintHex:(NSString*)hex placeholder:(NSString*)text;


// retrieve the data
-(NSString*)retrieveInput;

// check if the field is empty
-(BOOL)isEmpty;

@end
