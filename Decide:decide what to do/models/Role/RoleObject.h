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

-(instancetype)initWithName:(NSString*)name;

-(void)assignExtraChance:(NSInteger)percentage OfDoingTaskNamed:(NSString*)taskname;

@end
