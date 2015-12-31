//
//  DCForMeObject.h
//  Decide:decide what to do
//
//  Created by YINGGUANG CHEN on 4/10/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShouldGenerateResultCount.h"
#import "ShouldSaveOutputToFile.h"  

@interface DCForMeObject : NSObject<ShouldGenerateResultCount,ShouldSaveOutputToFile>

/**
 * @brief   Designated initializer
 */

-(id)initWithActivityList:(NSArray*)list;

/**
 
 * @brief   Add another activity
 
 * @param   Activity name
 
 * @return  void
 
 */
-(void)addActivity:(NSString*)activity;

/**
 
 * @brief   Remove an activity
 
 * @param   Activity name
 
 * @return  void
 
 */
-(void)removeActivity:(NSString*)activity;

/**
 
 * @brief   Remove all items
 
 * @param   nil
 
 * @return  void
 
 */
-(void)reset;

/**
 
 * @brief   Get lists of activities in NSString
 
 * @param   nil
 
 * @return  NSArray
 
 */
-(NSArray*)getListOfActivities;

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
