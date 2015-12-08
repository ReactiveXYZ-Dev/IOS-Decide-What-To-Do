//
//  DeicdeForGroupViewController.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 8/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DecideForGroupViewController.h"

#import "Helper.h"

@implementation DecideForGroupViewController

-(void)viewWillAppear:(BOOL)animated{
    
    
    
}


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    // set tabbar item image
    
    UITabBarItem* thisItem = self.tabBarController.tabBar.items[2];
    
    [thisItem setImage:[Helper resizeImageWithSourceName:@"decide_for_group" AndScale:2]];
    
}

@end
