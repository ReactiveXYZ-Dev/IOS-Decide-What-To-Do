//
//  Decide_decide_what_to_doTests.m
//  Decide:decide what to doTests
//
//  Created by YINGGUANG CHEN on 4/10/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RoleObject.h"
#import "DCForGroupObject.h"

@interface Decide_decide_what_to_doTests : XCTestCase

@end

@implementation Decide_decide_what_to_doTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSArray* listOfRoles = @[[RoleObject roleWithName:@"Jackie"],[RoleObject roleWithName:@"Echo"]];
    
    NSArray* listOfTasks = @[@"Wash dishes",@"cook meal",@"clean the beds"];
    
    DCForGroupObject* groupModel = [[DCForGroupObject alloc]initWithRoleList:listOfRoles AndTasks:listOfTasks];
    
    [groupModel assignExtraTasks:groupModel.getNumOfExtraTasksSomeoneHasToDo ToRoleWithName:@"Jackie"];
    
    [groupModel assignExtraChance:30 OfDoingTaskNamed:@"cook meal" ToRoleWithName:@"Echo"];
    
    NSArray* newDistribution = [groupModel decideWithSetPriority];
    
    NSLog(@"%@",newDistribution);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
