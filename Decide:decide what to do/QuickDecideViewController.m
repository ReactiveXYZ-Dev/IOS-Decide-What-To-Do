//
//  ViewController.m
//  Decide:decide what to do
//
//  Created by YINGGUANG CHEN on 4/10/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "QuickDecideViewController.h"

#import "QuickDecideObject.h"

#import "QDResultView.h"

#import "UIView+QuickSizeFetcher.h"

#import "Helper.h"

#import "KLCPopup.h"

@interface QuickDecideViewController (){

    QuickDecideObject* qdModel;
    
}

@property (strong,nonatomic) UIScrollView* container;

@property (strong,nonatomic) UIButton* decideBtn;

@property (strong,nonatomic) QDResultView* resultView;

@end

@implementation QuickDecideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create variables
    qdModel = [[QuickDecideObject alloc]init];
    
    // initialize container
    _container = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    [_container setScrollEnabled:YES];
    
    [self.view addSubview:_container];
    
    // add button
    _decideBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    float designatedSideLength = [self.view getFrameWidth] / 2.5;
    
    _decideBtn.frame = CGRectMake([self.view getFrameWidth] / 2 - designatedSideLength / 2, [self.view getFrameHeight] / 5, designatedSideLength, designatedSideLength);
    
    _decideBtn.layer.cornerRadius = [_decideBtn getBoundWidth] / 2;
    
    _decideBtn.layer.borderWidth = 1.0f;
    
    _decideBtn.layer.borderColor = _decideBtn.titleLabel.textColor.CGColor;
    
    [_decideBtn addTarget:self action:@selector(decideBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_decideBtn setTitle:@"Decide Now!" forState:UIControlStateNormal];
    
    [_container addSubview:_decideBtn];
    
    // add QDResult view
    _resultView = [[QDResultView alloc]initWithFrame:CGRectMake(0, [self.view getFrameHeight] - [self.view getBoundHeight] / 2.5, [self.view getFrameWidth], [self.view getFrameWidth])];
    
    [_container addSubview:_resultView];
    
    // resize content size
    CGRect contentRect = CGRectZero;
    
    for (UIView *view in _container.subviews) {
        
        contentRect = CGRectUnion(contentRect, view.frame);
        
    }
    _container.contentSize = contentRect.size;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)decideBtnPressed:(id)sender{
    
    BOOL result = [qdModel decide];
    
    if (result) {
        
        // YES
        [_resultView incrementYesCount];
        
    }else{
        
        // NO
        [_resultView incrementNoCount];
        
    }
    
}

#pragma mark - Tests

@end
