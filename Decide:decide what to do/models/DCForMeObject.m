//
//  DCForMeObject.m
//  Decide:decide what to do
//
//  Created by YINGGUANG CHEN on 4/10/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DCForMeObject.h"

@interface DCForMeObject (){
    
    
}
@property (nonatomic,strong) NSMutableArray* activityList;

@end

@implementation DCForMeObject

#pragma mark - Initializer

-(id)initWithActivityList:(NSArray *)list{
    
    if (self = [super init] ) {
        
        _activityList = [list mutableCopy];
        
    }
    
    return self;
    
}

-(id)init{
    @throw [NSException exceptionWithName:@"Use designated initializer" reason:@"Used default initializer" userInfo:nil];
}

#pragma mark - Main Methods

-(void)addActivity:(NSString *)activity{
    
    [_activityList addObject:activity];
    
}

-(void)removeActivity:(NSString *)activity{
    
    [_activityList removeObjectIdenticalTo:activity];
    
}

-(NSArray*)getListOfActivities{
    
    return [NSArray arrayWithArray:_activityList];
    
}

-(NSString*)decide{
    
    NSInteger length = _activityList.count;
    
    NSInteger randomIndex = arc4random() % length;
    
    NSString* result = _activityList[randomIndex];
    
    return result;
    
}

-(void)setCurrentWorkingSourceWithActivityList:(NSArray *)newSource{
    
    if (_activityList) {
        
        _activityList = [newSource mutableCopy];
        
    }
}


-(NSDictionary*)generateSavableOutput{
    
    //
    return nil;
}
@end
