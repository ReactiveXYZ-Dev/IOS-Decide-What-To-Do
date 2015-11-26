//
//  DCForGroupObject.h
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 26/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoleObject.h"
#import "ShouldSaveOutputToFile.h"
typedef NS_ENUM(NSInteger,RatioCheckedResult) {
    
    RatioCheckedOneToOne,
    
    RatioCheckedOverloaded,
    
    RatioCheckedUnderloaded,
    
    RatioCheckedUndefined
    
};

@interface DCForGroupObject : NSObject<ShouldSaveOutputToFile>

@property (assign,nonatomic) RatioCheckedResult checkedResult;

/**
 
 * @brief   Designated initializer with roles and tasks
 
 * @param   Roles array , Tasks array
 
 * @return  self
 
 */
-(instancetype)initWithRoleList:(NSArray*)roles AndTasks:(NSArray*)tasks;

/**
 
 * @brief   Adders/Removers for data sources
 
 * @param   mixed
 
 * @return  void
 
 */
-(void)addRole:(NSString*)role;

-(void)addTask:(NSString*)task;

-(void)removeRole:(RoleObject*)role;

-(void)removeTask:(RoleObject*)task;

/**
 
 * @brief   Check the ratio of number of tasks to role to identify if who has to do one more task
 
 * @param   nil
 
 * @return  RatioCheckedResult enum
 
 */
-(RatioCheckedResult)checkRoleTaskRatio;

/**
 
 * @brief   Decide for a group of people by assigning their tasks
 
 * @param   nil
 
 * @return  NSDictionary with key {role} : value {task}
 
 */
-(NSDictionary<RoleObject*,NSString*>*)decide;

/**
 
 * @brief   Delegated generate savable output
 
 */
-(NSDictionary*)generateSavableOutput;

@end
