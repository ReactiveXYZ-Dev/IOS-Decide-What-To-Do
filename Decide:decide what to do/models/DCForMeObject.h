//
//  DCForMeObject.h
//  Decide:decide what to do
//
//  Created by YINGGUANG CHEN on 4/10/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCForMeObject : NSObject

/**
 * @brief
 */

-(id)initWithActivityList:(NSArray*)list;

/**
 
 * @brief run the single decide for me event
 
 * @param nil
 
 * @return the selected item as a string
 
 */
-(NSString*)decide;

/**
 
 * @brief set the source for this model
 
 * @param new activity list source
 
 * @return void
 
 */
-(void)setCurrentWorkingSourceWithActivityList:(NSArray*)newSource;

/**
 
 * @brief generate output as dictionary to be saved
 
 * @param nil
 
 * @return NSDictionary
 
 */

-(NSDictionary*)generateSavableOutput;
@end
