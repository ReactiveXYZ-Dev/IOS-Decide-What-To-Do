//
//  QuickDecideObject.h
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 25/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShouldGenerateResultCount.h"

@interface QuickDecideObject : NSObject<ShouldGenerateResultCount>

@property (assign,nonatomic) NSInteger successCount;

@property (assign,nonatomic) NSInteger failureCount;

/**
 
 * @brief   Do a quick decide
 
 * @param   nil
 
 * @return  Boolean
 
 */
-(BOOL)decide;

/**
 
 * @brief   Generate a float showing the percentage of true corrected to 2 decimal places
 
 * @param   nil
 
 * @return  float
 
 */
-(float)getSuccessPercentage;



@end
