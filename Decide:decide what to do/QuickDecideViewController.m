//
//  ViewController.m
//  Decide:decide what to do
//
//  Created by YINGGUANG CHEN on 4/10/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

// normal VC stuff
#import <QuartzCore/QuartzCore.h>

#import "QuickDecideViewController.h"

#import "QuickDecideObject.h"

#import "QDResultView.h"

#import "UIView+QuickSizeFetcher.h"

#import "UIScrollView+UpdateContentSize.h"

#import "Helper.h"

#import "KLCPopup.h"

#import "ViewComposer.h"

// watch connectivity
#import <WatchConnectivity/WatchConnectivity.h>

@interface QuickDecideViewController ()<WCSessionDelegate>{

    QuickDecideObject* qdModel;
    
}

@property (strong,nonatomic) UIScrollView* container;

@property (strong,nonatomic) UIButton* decideBtn;

@property (strong,nonatomic) QDResultView* resultView;

@end

@implementation QuickDecideViewController

-(void)viewWillAppear:(BOOL)animated{
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load watch connectivity
    if ([WCSession isSupported]) {
        
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        
    }
    
    // create variables
    qdModel = [[QuickDecideObject alloc]init];
    
    // initialize container
    _container = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    [_container setScrollEnabled:YES];
    
    [self.view addSubview:_container];
    
    // add button
    _decideBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    float designatedSideLength = [self.view getFrameWidth] / 2;
    
    _decideBtn.frame = CGRectMake([self.view getFrameWidth] / 2 - designatedSideLength / 2, [self.view getFrameHeight] / 5, designatedSideLength, designatedSideLength);
    
    _decideBtn.layer.cornerRadius = [_decideBtn getBoundWidth] / 2;
    
    _decideBtn.layer.borderWidth = 1.0f;
    
    _decideBtn.layer.borderColor = _decideBtn.titleLabel.textColor.CGColor;
    
    [_decideBtn addTarget:self action:@selector(decideBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_decideBtn setTitle:@"Decide Now!" forState:UIControlStateNormal];
    
    [_decideBtn.titleLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:28]];
    
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
    KLCPopup* popup = [KLCPopup popupWithContentView:[[ViewComposer sharedComposer] composeQuickDecisionPopupWithResult:result actionTarget:self andSelector:@selector(dismissButtonPressed:)] showType:KLCPopupShowTypeBounceInFromTop dismissType:KLCPopupDismissTypeBounceOutToBottom maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    [popup show];
}

#pragma mark - WatchConnectivity Delegate
-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler{
    
    NSString* action = [message objectForKey:@"action"];
    
    if ([action isEqualToString:@"quick_decide"]) {
        
        BOOL result = [qdModel decide];
        
        NSLog(@"%i",(int)result);
        
        NSString* resultString = result?@"YES":@"NO";
        
        replyHandler(@{@"response":resultString});
        
        
    }
    
}

@end
