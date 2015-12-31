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

@property(strong,nonatomic)NSMutableArray<RoleObject*>* roles;

@property(strong,nonatomic)NSMutableArray* tasks;

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

-(void)removeRole:(NSString*)roleName;

-(void)removeTask:(NSString*)task;

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
 
 * @brief   Find index of a role with name
 
 * @param   NSString name
 
 * @return  NSInteger:name
 
 */
-(NSInteger)indexOfRoleWithName:(NSString*)name;

/**
 
 * @brief   Check if a role has already owned some privileges
 
 * @param   NSString roleName
 
 * @return  BOOL
 
 */
-(BOOL)isAlreadyVIPForRoleWithName:(NSString*)roleName;

/**
 
 * @brief   Decide for a group of people by assigning their tasks in a set priority, that is the first one in the role objects array get to choose first
 
 * @param   nil
 
 * @return  NSDictionary with key {role} : value {task}
 
 */
-(NSArray<RoleObject*> *)decideWithSetPriority;

/**
 
 * @brief   Decide for a group by assigning their tasks in a random priority, that is a random role is selected after each loop in an unordered manner
 
 * @param   nil
 
 * @return  NSArray
 
 */
-(NSArray<RoleObject*> *)decideWithRandomPriority;

/**
 
 * @brief   Remove all roles/tasks
 
 * @param   nil
 
 * @return  void
 
 */
-(void)reset;

/**
 
 * @brief   Reload roles and tasks with original data
 
 * @param   nil
 
 * @return  nil
 
 */
-(void)reloadData;

/**
 
 * @brief   Generate a random privilege percentage for a participant
 
 * @param   nil
 
 * @return  int
 
 */
-(int)generateLuckyPercentage;

/**
 
 * @brief   Delegated generate savable output
 
 */
-(NSDictionary*)generateSavableOutput;

@end
