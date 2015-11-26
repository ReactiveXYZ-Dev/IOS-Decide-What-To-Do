//
//  DCForGroupObject.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 26/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DCForGroupObject.h"

@interface DCForGroupObject()

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
        
        _roles = [roles mutableCopy];
        
        _tasks = [tasks mutableCopy];
        
    }

    return self;
}

#pragma mark - Main methods

-(void)addRole:(RoleObject *)role{
    
    [_roles addObject:role];
    
}

-(void)removeRole:(RoleObject *)role{
    
    [_roles removeObjectIdenticalTo:role];
    
}

-(void)addTask:(NSString *)task{
    
    [_tasks addObject:task];
    
}

-(void)removeTask:(NSString *)task{
    
    [_tasks removeObjectIdenticalTo:task];
}

-(RatioCheckedResult)checkRoleTaskRatio{
    
    NSUInteger roleCount = _roles.count;
    
    NSUInteger taskCount = _tasks.count;
    
    if (roleCount == taskCount) {
        
        _checkedResult = RatioCheckedOneToOne;
        
        return RatioCheckedOneToOne;
        
    }
    
    if (roleCount > taskCount) {
        
        _checkedResult = RatioCheckedUnderloaded;
        
        return RatioCheckedUnderloaded;
        
    }
    
    if (roleCount < taskCount) {
        
        _checkedResult = RatioCheckedOverloaded;
        
        return RatioCheckedOverloaded;
        
    }
    
    _checkedResult = RatioCheckedUndefined;
    
    return RatioCheckedUndefined;
}

-(NSDictionary<RoleObject*,NSString*>*)decide{
    
    //
    
}


#pragma mark - Delegated methods
-(NSDictionary*)generateSavableOutput{
    
    //
    return nil;
    
}





@end
