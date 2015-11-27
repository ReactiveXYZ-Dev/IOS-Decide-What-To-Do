//
//  DCForGroupObject.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 26/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DCForGroupObject.h"

@interface DCForGroupObject(){
    
    long numOfTasksForEachRole;
    
    long numOfExtraTasksSomeoneHasToDo;
    
}

@property(strong,nonatomic)NSMutableArray<RoleObject*>* roles;

@property(strong,nonatomic)NSMutableArray* tasks;

@end

@implementation DCForGroupObject

#pragma mark - Initializers

-(instancetype)init{
    
    @throw [NSException exceptionWithName:@"Used default initializer" reason:@"Designated initializer implemented" userInfo:nil];
}

-(instancetype)initWithRoleList:(NSArray *)roles AndTasks:(NSArray *)tasks{
    
    if (self = [super init]) {
        
        // init data source
        _roles = [roles mutableCopy];
        
        _tasks = [tasks mutableCopy];
        
        // set num of tasks to do for each role
        [self assignBasicNumOfTasksToEachRole];
        
    }

    return self;
}

#pragma mark - Main methods

-(long)getNumOfTasksForEachRole{
    
    return numOfTasksForEachRole;
    
}

-(long)getNumOfExtraTasksSomeoneHasToDo{
    
    return numOfExtraTasksSomeoneHasToDo;
    
}

-(void)assignBasicNumOfTasksToEachRole{
    
    // if perfectly distributed
    if (_tasks.count % _roles.count == 0) {
        
        numOfTasksForEachRole = _tasks.count / _roles.count;
        
        numOfExtraTasksSomeoneHasToDo = 0;
        
    }else{
        
        // someone has to do some extra tasks
        
        int numOfTasks = 1;
        
        while (_roles.count * numOfTasks < _tasks.count) {
            
            numOfTasks ++ ;
            
        }
        
        numOfTasksForEachRole = numOfTasks - 1;
        
        numOfExtraTasksSomeoneHasToDo = _tasks.count % _roles.count;
        
    }
    
    for (RoleObject* role in _roles) {
        
        role.numOfTasksToDo = numOfTasksForEachRole;
        
    }
    
}

-(void)addRole:(RoleObject *)role{
    
    [_roles addObject:role];
    
}

-(void)removeRole:(RoleObject *)role{
    
    [_roles removeObject:role];
    
}

-(void)addTask:(NSString *)task{
    
    [_tasks addObject:task];
    
}

-(void)removeTask:(NSString *)task{
    
    [_tasks removeObject:task];
}

-(void)assignExtraTasks:(NSInteger)numOfTasks ToRoleWithName:(NSString *)rolename{
    
    for (RoleObject* role in _roles) {
        
        if (role.name == rolename) {
            
            role.numOfTasksToDo += numOfTasks ;
            
            break;
            
        }
        
    }
    
}

-(void)assignNumOfTasks:(NSInteger)numOfTasks ToRoleWithName:(NSString *)rolename{
    
    for (RoleObject* role in _roles) {
        
        if (role.name == rolename) {
            
            role.numOfTasksToDo = numOfTasks ;
            
            break;
            
        }
        
    }
    
}

-(void)assignExtraChance:(int)percentage OfDoingTaskNamed:(NSString *)taskname ToRoleWithName:(NSString *)name{
    
    for (RoleObject* role in _roles) {
        
        if (role.name == name) {
            
            [role assignExtraChance:percentage OfDoingTaskNamed:taskname];
            
            break;
            
        }
        
    }
    
}

-(RatioCheckedResult)checkRoleTaskRatio{
    
    NSUInteger roleCount = _roles.count;
    
    NSUInteger taskCount = _tasks.count;
    
    if (taskCount % roleCount == 0) {
        
        _checkedResult = RatioCheckedEquallyAssigned;
        
        return RatioCheckedEquallyAssigned;
        
    }
    
    if (roleCount > taskCount) {
        
        _checkedResult = RatioCheckedUnderloaded;
        
        return RatioCheckedUnderloaded;
        
    }
    
    if (numOfExtraTasksSomeoneHasToDo > 0) {
        
        _checkedResult = RatioCheckedOverloaded;
        
        return RatioCheckedOverloaded;
        
    }
    
    _checkedResult = RatioCheckedUndefined;
    
    return RatioCheckedUndefined;
}



-(NSArray<RoleObject*>*)decide{
    
    // loop through roles
    for (RoleObject* role in _roles) {
        
        // check tasks assigned with extra chance
        NSArray* tasksWithExtraChance = [role retrieveTasksWithExtraChance];
        
        // loop through these tasks in prior
        for (NSString* task in tasksWithExtraChance) {
            
            // check if the task still exists
            if ([_tasks containsObject:task]) {
                
                BOOL chanceOfSuccessfulAssignment = [self chanceWithYESPercentage:50+50*([role retrieveChanceOfDoingTaskName:task]/100)];
                
                NSLog(@"%i",[self chanceWithYESPercentage:50+50*([role retrieveChanceOfDoingTaskName:task]/100)]);
                
                if (chanceOfSuccessfulAssignment) {
                    
                    // successful get the task
                    [role assignTask:task];
                    
                    // remove the task from the list
                    [_tasks removeObject:task];
                }
                
            }
            
        }
        
        // check if there are still tasks for this role that
        // needs to be assigned
        NSInteger remainings = role.numOfTasksToDo;
        
        NSLog(@"name:%@,remainings: %i",role.name,remainings);
        
        while (remainings > 0) {
            
            // select a random task
            NSString* task = _tasks[arc4random_uniform((int)_tasks.count)];
            
            // assign and remove task
            [role assignTask:task];
            
            [_tasks removeObject:task];
            
            remainings --;
            
        }
        NSLog(@"name:%@,%@",role.name,role.retrieveAssignedTasks);

    }
    
    return [_roles copy];
}

-(BOOL)chanceWithYESPercentage:(long)percentage{
    
    return arc4random_uniform(100) < percentage;
    
}

#pragma mark - Delegated methods
-(NSDictionary*)generateSavableOutput{
    
    //
    return nil;
    
}





@end
