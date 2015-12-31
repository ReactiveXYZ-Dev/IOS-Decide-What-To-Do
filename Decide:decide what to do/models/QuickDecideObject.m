//
//  QuickDecideObject.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 25/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "QuickDecideObject.h"
#import "NSNumber+RoundingUp.h"

@implementation QuickDecideObject

#pragma mark - Initializer
-(instancetype)init{
    
    if (self = [super init]) {
        
        _successCount = 0;
        
        _failureCount = 0;
        
    }
    
    return self;
    
}

#pragma mark - Main methods
-(BOOL)decide{
    
    int chance = arc4random_uniform(100);
    
    if (chance < 50) {
        
        // No
        [self incrementSuccessCount];
        
        return NO;
        
    }else{
        
        // Yes
        [self incrementFailureCount];
        
        return YES;
        
    }
    
}


-(void)incrementSuccessCount{
    
    self.successCount ++;
    
}

-(void)incrementFailureCount{
    
    self.successCount --;
    
}


-(float)getSuccessPercentage{
    
    NSNumber* percentageNumber = [NSNumber numberWithFloat:_successCount * 100 / (_successCount + _failureCount)];
    
    return [percentageNumber floatByRounding:NSNumberFormatterRoundUp toPositionRightOfDecimal:2];
    
}

-(void)reset{
    
    
}



@end
