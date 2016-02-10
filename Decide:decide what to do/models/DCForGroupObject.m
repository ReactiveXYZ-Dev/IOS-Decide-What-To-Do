//
//  DCForGroupObject.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 26/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DCForGroupObject.h"

#import "Helper.h"

@interface DCForGroupObject(){
    
    long numOfTasksForEachRole;
    
    long numOfExtraTasksSomeoneHasToDo;
    
}

@property (strong,nonatomic)NSMutableArray<RoleObject*>* rolesCopy;

@property (strong,nonatomic)NSMutableArray* tasksCopy;

@end

@implementation DCForGroupObject

#pragma mark - Initializers

-(instancetype)init{
    
    @throw [NSException exceptionWithName:@"Used default initializer" reason:@"Designated initializer implemented" userInfo:nil];
}

-(instancetype)initWithRoleList:(NSArray *)roles AndTasks:(NSArray *)tasks{
    
    if (self = [super init]) {
        
        // init variables
        _roles = [[NSMutableArray alloc]init];
        
        _tasks = [[NSMutableArray alloc]init];
        
        // load the roles data
        for (NSString* roleName in roles) {
            
            [self addRole:roleName];
            
        }
        
        // load the tasks data
        _tasks = [NSMutableArray arrayWithArray:tasks];
        
        // prepare copies of data for future use
        [self prepareCopiesOfData];
        
        // set num of tasks to do for each role
        if (_roles.count == 0 || tasks.count == 0) {
            
            numOfExtraTasksSomeoneHasToDo = 0;
            
            numOfTasksForEachRole = 0;
            
        }else{
            
          [self autoAssignTasksToEachRole];
            
        }
        
        
    }

    return self;
}

-(void)prepareCopiesOfData{
    
    _rolesCopy = [NSMutableArray arrayWithArray:[_roles mutableCopy]];
    
    _tasksCopy = [NSMutableArray arrayWithArray:[_tasks mutableCopy]];
    
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

-(void)addRole:(NSString *)roleName{
    
    [_roles addObject:[[RoleObject alloc]initWithName:roleName]];
    
    [self prepareCopiesOfData];
    
}

-(void)removeRole:(NSString *)roleName{
    
    [_roles removeObject:[self findRoleWithName:roleName]];
    
    [self prepareCopiesOfData];
    
}

-(void)addTask:(NSString *)task{
    
    [_tasks addObject:task];
    
    [self prepareCopiesOfData];
    
}

-(void)removeTask:(NSString *)task{

    [_tasks removeObject:task];
    
    [self prepareCopiesOfData];
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

-(NSInteger)indexOfRoleWithName:(NSString *)name{
    
    for (int i = 0 ; i <=_roles.count; i++) {
        
        if ([_roles[i].name isEqualToString:name]) {
            
            return i;
            
        }
        
    }
    
    return 0;
    
}

-(BOOL)isAlreadyVIPForRoleWithName:(NSString *)roleName{
    
    return [[self findRoleWithName:roleName] isAlreadyVIP];
    
}

-(NSArray<RoleObject*>*)decideWithSetPriority{
    
    [Helper incrementDecisionCount];
    
    // reassign number of tasks
    [self autoAssignTasksToEachRole];
    
    // loop through roles
    for (RoleObject* role in _roles) {
        
        // modify the role
        [self modifyRole:role];
    }
    
    return _roles;
}

-(NSArray<RoleObject*> *)decideWithRandomPriority{
    
    [Helper incrementDecisionCount];
    
    // reassign number of tasks
    [self autoAssignTasksToEachRole];
    
    // initialize the index array
    NSMutableArray<NSNumber*>* indexArray = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < _roles.count; i++) {
        
        [indexArray addObject:@(i)];
        
    }
    
    // loop through and choose a random index
    while (indexArray.count > 0) {
        // get a random index
        NSNumber* randomIndex = indexArray[arc4random_uniform((int)indexArray.count-1)];
        
        int actualIndex = [randomIndex intValue];
        
        // modify the role
        RoleObject* role = _roles[actualIndex];
        
        [self modifyRole:role];
        
        // rebuild index array so that the while loop can be ended
        [indexArray removeObject:randomIndex];
        
    }
    
    return _roles;
    
}

-(void)reset{
    
    [_roles removeAllObjects];
    
    [_tasks removeAllObjects];
    
    numOfExtraTasksSomeoneHasToDo = 0;
    
    numOfTasksForEachRole = 0;
    
    _rolesCopy = nil;
    
    _tasksCopy = nil;
    
}

-(void)reloadData{
    //@weird: the rolescopy objects is still changing,
    // below is just a quick fix
    
    // reset source
    for (RoleObject* role in _roles) {
        
        [role reload];
        
    }
    
    _tasks = [_tasksCopy mutableCopy];
    
}

-(int)generateLuckyPercentage{
    
    return arc4random_uniform(50);
    
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
    //NSInteger remainings = role.numOfTasksToDo;
    
    NSInteger remainings = [[@(role.numOfTasksToDo) copy] integerValue];
    
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
