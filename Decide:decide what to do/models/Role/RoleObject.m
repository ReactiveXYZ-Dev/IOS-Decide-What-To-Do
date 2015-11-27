//
//  RoleObject.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 26/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "RoleObject.h"

@implementation RoleObject{
    
    NSMutableDictionary* chanceMap;
    
    NSMutableArray* assignedTasks;
    
}

+(instancetype)roleWithName:(NSString* )name{
    
    return [[RoleObject alloc]initWithName:name];
    
}

-(instancetype)initWithName:(NSString *)name{
    
    if (self = [super init]) {
        
        _name = name;
        
        _numOfTasksToDo = 1;
        
        chanceMap = [[NSMutableDictionary alloc]init];
        
        assignedTasks = [[NSMutableArray alloc]init];
        
    }
    
    return self;
    
}

-(void)assignExtraChance:(NSInteger)percentage OfDoingTaskNamed:(NSString *)taskname{
    
    chanceMap[taskname] = [NSNumber numberWithInteger:percentage];
    
}

-(NSInteger)retrieveChanceOfDoingTaskName:(NSString *)taskname{
    
    return [(NSNumber*)chanceMap[taskname] integerValue];
}

-(NSArray*)retrieveTasksWithExtraChance{
    
    return [chanceMap allKeys];
    
}

-(void)assignTask:(NSString *)task{
    
    [assignedTasks addObject:task];
    
    _numOfTasksToDo --;
}

-(NSArray*)retrieveAssignedTasks{
        
    return [NSArray arrayWithArray:assignedTasks];
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"A role with name %@ and assigned with %li tasks which are %@", _name,(long)assignedTasks.count,assignedTasks];
}

-(NSUInteger)hash{
    
    return [_name hash] + [chanceMap hash] + _numOfTasksToDo;
    
}

-(BOOL)isEqual:(id)object{
    
    if (object == self) {
        
        return YES;
        
    }
    
    if (!object || ![object isKindOfClass:[self class]]) {
        
        return NO;
        
    }
    
    return [self isEqualToAnotherRole:(RoleObject*)object];
    
}

-(BOOL)isEqualToAnotherRole:(RoleObject*)anotherRole{
    
    if ([self hash] == [anotherRole hash]) {
        
        return YES;
        
    }
    
    return NO;
}
@end
