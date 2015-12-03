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
        
        // set up texts
        _yesTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [self getFrameWidth] / 2, 25)];
        
        [_yesTitleLabel setTextAlignment:NSTextAlignmentCenter];
        
        _yesTitleLabel.text = @"YES?";
        
        [self addSubview:_yesTitleLabel];
        
        _noTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake([self getFrameWidth] / 2, 15, [self getFrameWidth] / 2, 25)];
        
        [_noTitleLabel setTextAlignment:NSTextAlignmentCenter];
        
        _noTitleLabel.text = @"NO?";
        
        [self addSubview:_noTitleLabel];
        
        _yesCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [_yesTitleLabel getFrameOriginY] + [_yesTitleLabel getFrameHeight], [self getFrameWidth] / 2, 30)];
        
        [_yesCountLabel setTextAlignment:NSTextAlignmentCenter];
        
        _yesCountLabel.text = [Helper stringWithInteger:yesCount];
        
        [self addSubview:_yesCountLabel];
        
        _noCountLabel = [[UILabel alloc]initWithFrame:CGRectMake([self getFrameWidth] / 2, [_noTitleLabel getFrameOriginY]+[_noTitleLabel getFrameHeight], [self getFrameWidth] / 2, 30)];
        
        [_noCountLabel setTextAlignment:NSTextAlignmentCenter];
        
        _noCountLabel.text = [Helper stringWithInteger:noCount];
        
        [self addSubview:_noCountLabel];
        
        // initialize the pie and its container
        _pieContainer = [[UIView alloc]initWithFrame:CGRectMake(0, [_noCountLabel getFrameOriginY] + [_noCountLabel getFrameHeight], [self getFrameWidth] , [self getFrameWidth])];
        
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
    
    
    
}

-(void)incrementNoCount {
    
    
    
}

#pragma mark - private methods
-(void)updatePie{
    
    // no values
    if (_pieChart.values.count == 0) {
        
        // add YES part
        [_pieChart addValues:@[[PieElement pieElementWithValue:yesCount color:[UIColor redColor]]] animated:YES];
        
        
    }
    
}

@end
