//
//  ViewController.m
//  Decide:decide what to do
//
//  Created by YINGGUANG CHEN on 4/10/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "QuickDecideViewController.h"

#import "QuickDecideObject.h"

#import "QDResultView.h"

#import "UIView+QuickSizeFetcher.h"

#import "Helper.h"

@interface QuickDecideViewController (){

    QuickDecideObject* qdModel;
    
}

@property (strong,nonatomic) UIScrollView* container;

@end

@implementation QuickDecideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize container
    _container = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:_container];
    
    // add button
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Tests

@end
