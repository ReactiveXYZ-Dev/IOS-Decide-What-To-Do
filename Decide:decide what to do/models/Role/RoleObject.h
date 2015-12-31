//
//  RoleObject.h
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 26/11/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoleObject : NSObject

@property (strong,nonatomic) NSString* name;

@property (assign,nonatomic) NSInteger numOfTasksToDo;

+(instancetype)roleWithName:(NSString* )name;

-(instancetype)initWithName:(NSString*)name;

-(void)assignExtraChance:(NSInteger)percentage OfDoingTaskNamed:(NSString*)taskname;

-(NSInteger)retrieveChanceOfDoingTaskName:(NSString*)taskname;

-(NSArray*)retrieveTasksWithExtraChance;

-(void)assignTask:(NSString*)task;

-(NSArray*)retrieveAssignedTasks;

-(BOOL)isAlreadyVIP;

-(void)reload;

@end
