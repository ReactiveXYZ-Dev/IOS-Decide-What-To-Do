//
//  ShouldGenerateResultCount.h
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 25/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

@protocol ShouldGenerateResultCount

@optional

-(void)getSuccessPercentage;

-(NSDictionary*)getSuccessPercentageForItemsInResultList;

@end
