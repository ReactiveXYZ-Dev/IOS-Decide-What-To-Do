//
//  RootTabBarViewController.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 8/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "RootTabBarViewController.h"

#import "Helper.h"

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self.tabBar.items[0] setImage:[Helper resizeImageWithSourceName:@"quick_decide" AndScale:2]];
    
    [self.tabBar.items[1] setImage:[Helper resizeImageWithSourceName:@"decide_for_me" AndScale:2]];
    
    [self.tabBar.items[2] setImage:[Helper resizeImageWithSourceName:@"decide_for_group" AndScale:2]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
