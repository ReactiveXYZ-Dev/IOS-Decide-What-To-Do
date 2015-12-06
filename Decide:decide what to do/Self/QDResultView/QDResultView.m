//
//  QDResultView.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 3/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "QDResultView.h"

#import "MagicPieLayer.h"

#import "UIView+QuickSizeFetcher.h"

#import "Helper.h"

@interface QDResultView(){
    
    NSInteger yesCount;
    
    NSInteger noCount;
    
}

// Text
@property (strong,nonatomic) UILabel* yesTitleLabel;

@property (strong,nonatomic) UILabel* noTitleLabel;

@property (strong,nonatomic) UILabel* yesCountLabel;

@property (strong,nonatomic) UILabel* noCountLabel;

// The Pie
@property (strong,nonatomic) UIView* pieContainer;

@property (strong,nonatomic) PieLayer* pieChart;

@end


@implementation QDResultView

#pragma mark - Initialize
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // set up variables
        yesCount = 0;
        
        noCount = 0;
        
        // set up texts and their container
        _yesTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, [self getFrameWidth] / 2 - 15, 25)];
        
        [_yesTitleLabel setTextAlignment:NSTextAlignmentCenter];
        
        _yesTitleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12];
        
        _yesTitleLabel.text = @"Got it!";
        
        [self addSubview:_yesTitleLabel];
        
        _noTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake([self getFrameWidth] / 2, 0, [self getFrameWidth] / 2 - 15, 25)];
        
        [_noTitleLabel setTextAlignment:NSTextAlignmentCenter];
        
        _noTitleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:12];
        
        _noTitleLabel.text = @"Not really";
        
        [self addSubview:_noTitleLabel];
        
        _yesCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, [_yesTitleLabel getFrameOriginY] + [_yesTitleLabel getFrameHeight], [self getFrameWidth] / 2 - 15, 30)];
        
        [_yesCountLabel setTextAlignment:NSTextAlignmentCenter];
        
        _yesCountLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:16];
        
        _yesCountLabel.text = [Helper stringWithInteger:yesCount];
        
        [self addSubview:_yesCountLabel];
        
        _noCountLabel = [[UILabel alloc]initWithFrame:CGRectMake([self getFrameWidth] / 2, [_noTitleLabel getFrameOriginY]+[_noTitleLabel getFrameHeight], [self getFrameWidth] / 2 - 15, 30)];
        
        [_noCountLabel setTextAlignment:NSTextAlignmentCenter];
        
        _noCountLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:16];
        
        _noCountLabel.text = [Helper stringWithInteger:noCount];
        
        [self addSubview:_noCountLabel];
        
        // initialize the pie and its container
        _pieContainer = [[UIView alloc]initWithFrame:CGRectMake(0, [_noCountLabel getFrameOriginY] , [self getFrameWidth] , [self getFrameWidth])];
        
        _pieContainer.bounds = CGRectInset(_pieContainer.frame, 25, 25);
        
        [self addSubview:_pieContainer];
        
        _pieChart = [[PieLayer alloc]init];
        
        _pieChart.frame = _pieContainer.bounds;
        
        [_pieContainer.layer addSublayer:_pieChart];
        
        [self addSubview:_pieContainer];

        
    }
    
    return self;
    
}

#pragma mark - public methods

-(void)incrementYesCount {
    
    yesCount ++ ;
    
    [self updateLabel:@"yes"];
    
    [self updatePie];
    
}

-(void)incrementNoCount {
    
    noCount ++ ;
    
    [self updateLabel:@"no"];
    
    [self updatePie];
    
}

#pragma mark - private methods
-(void)updateLabel:(NSString*)type{
    
    // define animation/transition
    CATransition* transition = [[CATransition alloc]init];
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    transition.type = kCATransitionPush;
    
    transition.duration = 0.35f;
    
    if ([type  isEqual: @"yes"]) {
        
        [_yesCountLabel.layer addAnimation:transition forKey:kCATransitionPush];
        
        _yesCountLabel.text = [Helper stringWithInteger:yesCount];
        
    }
    
    if ([type isEqual: @"no"]) {
        
        [_noCountLabel.layer addAnimation:transition forKey:kCATransitionPush];
        
        _noCountLabel.text = [Helper stringWithInteger:noCount];
        
    }
    
}


-(void)updatePie{
    
    // no values
    if (_pieChart.values.count == 0) {
        
        // add YES part
        [_pieChart addValues:@[
                               [PieElement pieElementWithValue:yesCount color:[UIColor colorWithRed:0.40 green:0.73 blue:0.42 alpha:1.0]],
                               [PieElement pieElementWithValue:noCount color:[UIColor colorWithRed:0.94 green:0.33 blue:0.31 alpha:1.0]]
                               ]
        animated:YES];
        
    }// has values
    else{
        
        // animate YES
        PieElement* yesElement = _pieChart.values[0];
        
        [PieElement animateChanges:^(void){
            
            yesElement.val = yesCount;
            
        }];
        
        // animate NO
        PieElement* noElement = _pieChart.values[1];
        
        [PieElement animateChanges:^(void){
           
            noElement.val = noCount;
            
        }];
        
    }
    
}

#pragma mark - overridden methods
-(void)dealloc{
    
    
    
}

@end
