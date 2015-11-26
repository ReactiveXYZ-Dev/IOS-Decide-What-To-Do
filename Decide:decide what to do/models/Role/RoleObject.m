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
    
}


-(instancetype)initWithName:(NSString *)name{
    
    if (self = [super init]) {
        
        _name = name;
        
        _numOfTasksToDo = 1;
        
        chanceMap = [[NSMutableDictionary alloc]init];
        
    }
    
    return self;
    
}

-(void)assignExtraChance:(NSInteger)percentage OfDoingTaskNamed:(NSString *)taskname{
    
    chanceMap[taskname] = [NSNumber numberWithInteger:percentage];
    
}
@end
