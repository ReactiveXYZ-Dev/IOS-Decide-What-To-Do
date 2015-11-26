//
//  NSNumber+RoundingUp.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 25/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "NSNumber+RoundingUp.h"

@implementation NSNumber(RoundingUp)

-(float)floatByRounding:(NSNumberFormatterRoundingMode)roundingMode toPositionRightOfDecimal:(NSUInteger)position{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setMaximumFractionDigits:position];
    
    [formatter setRoundingMode:roundingMode];
    
    NSString* result = [formatter stringFromNumber:self];
    
    return result.floatValue;
    
}

@end
