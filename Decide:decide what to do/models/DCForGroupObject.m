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
    
    NSMutableArray<RoleObject*>* rolesCopy;
    
    NSMutableArray* tasksCopy;
    
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
        
        // prepare copies of data for future use
        [self prepareCopiesOfData];
        
        // set num of tasks to do for each role
        [self autoAssignTasksToEachRole];
        
    }

    return self;
}

-(void)prepareCopiesOfData{
    
    rolesCopy = [_roles mutableCopy];
    
    tasksCopy = [_tasks mutableCopy];
    
}

#pragma mark - Main methods

-(long)getNumOfTasksForEachRole{
    
    return numOfTasksForEachRole;
    
}

-(long)getNumOfExtraTasksSomeoneHasToDo{
    
    return numOfExtraTasksSomeoneHasToDo;
    
}

-(void)autoAssignTasksToEachRole{
    
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
    
    // assign the num to each role
    
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
    
    RoleObject* selected = [self findRoleWithName:rolename];
    
    if (selected) {
        
        selected.numOfTasksToDo += numOfTasks ;
        
    }
    
}

-(void)assignNumOfTasks:(NSInteger)numOfTasks ToRoleWithName:(NSString *)rolename{
    
    RoleObject* selected = [self findRoleWithName:rolename];
    
    if (selected) {
        
        selected.numOfTasksToDo = numOfTasks ;
        
    }
    
}

-(void)assignExtraChance:(int)percentage OfDoingTaskNamed:(NSString *)taskname ToRoleWithName:(NSString *)name{
    
    RoleObject* selected = [self findRoleWithName:name];
    
    if (selected) {
        
        [selected assignExtraChance:percentage OfDoingTaskNamed:taskname];
        
    }
    
}

-(void)swapRoleIndexWithName:(NSString *)toBeSwapped With:(NSString *)substitute{
    
    NSUInteger indexToBeSwapped = [_roles indexOfObject:[self findRoleWithName:toBeSwapped]];
                                   
    NSUInteger indexOfSubstitution = [_roles indexOfObject:[self findRoleWithName:substitute]];
    
    [_roles exchangeObjectAtIndex:indexToBeSwapped withObjectAtIndex:indexOfSubstitution];
    
}

-(RoleObject*)findRoleWithName:(NSString*)name{
    
    for (RoleObject* role in _roles) {
        
        if (role.name == name) {
            
            return role;
            
        }
        
    }
    
    return nil;
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



-(NSArray<RoleObject*>*)decideWithSetPriority{
    
    // loop through roles
    for (RoleObject* role in _roles) {
        
        // modify the role
        [self modifyRole:role];
    }
    
    return [_roles copy];
}

-(NSArray<RoleObject*> *)decideWithRandomPriority{
    
    
    
    // initialize the index array
    NSMutableArray<NSNumber*>* indexArray = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < _roles.count; i++) {
        
        [indexArray addObject:@(i)];
        
    }
    
    // loop through and choose a random index
    while (indexArray.count > 0) {
        
        // get a random index
        NSNumber* randomIndex = indexArray[arc4random_uniform((int)_roles.count)];
        
        int actualIndex = [randomIndex intValue];
        
        // modify the role
        RoleObject* role = _roles[actualIndex];
        
        [self modifyRole:role];
        
        // remove the index from index array so that the while loop can be ended
        [indexArray removeObject:randomIndex];
        
    }
    
    return [_roles copy];
    
}

-(void)modifyRole:(RoleObject*)role{
    
    // check tasks assigned with extra chance
    NSArray* tasksWithExtraChance = [role retrieveTasksWithExtraChance];
    
    // loop through these tasks in prior
    for (NSString* task in tasksWithExtraChance) {
        
        // check if the task still exists
        if ([_tasks containsObject:task]) {
            
            BOOL chanceOfSuccessfulAssignment = [self chanceWithYESPercentage:50+50*([role retrieveChanceOfDoingTaskName:task]/100)];
            
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
    
    while (remainings > 0) {
        
        // select a random task
        NSString* task = _tasks[arc4random_uniform((int)_tasks.count)];
        
        // assign and remove task
        [role assignTask:task];
        
        [_tasks removeObject:task];
        
        remainings --;
        
    }

    
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
