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

#import "UIScrollView+UpdateContentSize.h"

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

-(void)viewWillAppear:(BOOL)animated{
    
    // set tabbar item image
    
    UITabBarItem* thisItem = self.tabBarController.tabBar.items[0];
    
    [thisItem setImage:[Helper resizeImageWithSourceName:@"quick_decide" AndScale:2]];
}

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
    [_container updateContentSize];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Methods
-(UIView*)generatePopupResultViewWithDecision:(BOOL)result{
    
    NSString* resultString = [[NSString alloc]init];
    
    if (result) {
        
        resultString = @"YES";
        
    }else{
        
        resultString = @"NO";
        
    }
    
    // Generate content view to present
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor colorWithRed:(184.0/255.0) green:(233.0/255.0) blue:(122.0/255.0) alpha:1.0];
    contentView.layer.cornerRadius = 12.0;
    
    UILabel* dismissLabel = [[UILabel alloc] init];
    dismissLabel.translatesAutoresizingMaskIntoConstraints = NO;
    dismissLabel.backgroundColor = [UIColor clearColor];
    dismissLabel.textColor = [UIColor whiteColor];
    dismissLabel.font = [UIFont boldSystemFontOfSize:72.0];
    dismissLabel.text = resultString;
    
    UIButton* dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    dismissButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    dismissButton.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(204.0/255.0) blue:(134.0/255.0) alpha:1.0];
    [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismissButton setTitleColor:[[dismissButton titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    dismissButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [dismissButton setTitle:@"Alright" forState:UIControlStateNormal];
    dismissButton.layer.cornerRadius = 6.0;
    [dismissButton addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:dismissLabel];
    [contentView addSubview:dismissButton];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(contentView, dismissButton, dismissLabel);
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(16)-[dismissLabel]-(10)-[dismissButton]-(24)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(36)-[dismissLabel]-(36)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    return contentView;
    
}

-(void)dismissButtonPressed:(id)sender
{
    
    if ([sender isKindOfClass:[UIView class]]) {
        
        [(UIView*)sender dismissPresentingPopup];
        
    }
    
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
    
    // present popup
    KLCPopup* popup = [KLCPopup popupWithContentView:[self generatePopupResultViewWithDecision:result] showType:KLCPopupShowTypeBounceInFromTop dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    [popup show];
}

#pragma mark - Tests

@end
