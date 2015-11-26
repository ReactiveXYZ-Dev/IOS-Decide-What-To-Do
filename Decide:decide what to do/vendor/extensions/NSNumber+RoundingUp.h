//
//  NSNumber+RoundingUp.h
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 25/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber(RoundingUp)

/**
 
 * @brief   Round NSNumber float to certain decimal places
 
 * @param   roudingMode , decimal places
 
 * @return  float
 
 */
- (float)floatByRounding:(NSNumberFormatterRoundingMode)roundingMode
      toPositionRightOfDecimal:(NSUInteger)position;

@end
