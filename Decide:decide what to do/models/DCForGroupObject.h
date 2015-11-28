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
    
    RatioCheckedEquallyAssigned,
    
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

-(void)assignExtraTasks:(NSInteger)numOfTasks ToRoleWithName:(NSString *)rolename;

-(void)assignNumOfTasks:(NSInteger)numOfTasks ToRoleWithName:(NSString *)rolename;

-(void)assignExtraChance:(int)percentage OfDoingTaskNamed:(NSString *)taskname ToRoleWithName:(NSString*)name;

-(void)swapRoleIndexWithName:(NSString*)toBeSwapped With:(NSString*)substitute;
/**
 
 * @brief   Check the ratio of number of tasks to role to identify if who has to do one more task
 
 * @param   nil
 
 * @return  RatioCheckedResult enum
 
 */
-(RatioCheckedResult)checkRoleTaskRatio;

/**
 
 * @brief   Getters for the num of tasks one basically has to do
 
 * @param   nil
 
 * @return  long:number of tasks
 
 */
-(long)getNumOfTasksForEachRole;

-(long)getNumOfExtraTasksSomeoneHasToDo;

/**
 
 * @brief   Decide for a group of people by assigning their tasks in a set priority, that is the first one in the role objects array get to choose first
 
 * @param   nil
 
 * @return  NSDictionary with key {role} : value {task}
 
 */
-(NSArray<RoleObject*> *)decideWithSetPriority;

/**
 
 * @brief   Decide for a group by assigning their tasks in a random priority, that is a random role is selected after each loop in an unordered manner
 
 * @param
 
 * @return
 
 */
-(NSArray<RoleObject*> *)decideWithRandomPriority;

/**
 
 * @brief   Delegated generate savable output
 
 */
-(NSDictionary*)generateSavableOutput;

@end
