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
@interface QuickDecideViewController (){

    QDResultView* testView;
    
}

//@property (strong,nonatomic) UIScrollView* container;

@end

@implementation QuickDecideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize container
    
    // test view
    testView = [[QDResultView alloc]initWithFrame:CGRectMake(0, 64, [self.view getFrameWidth], [self.view getFrameHeight])];
    
    [self.view addSubview:testView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Tests

- (IBAction)increseYes:(id)sender {
    
    [testView incrementYesCount];
    
}


- (IBAction)increaseNo:(id)sender {
    
    [testView incrementNoCount];
}

@end
