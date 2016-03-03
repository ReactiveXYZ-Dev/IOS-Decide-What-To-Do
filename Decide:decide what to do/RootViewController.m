//
//  RootViewController.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 31/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "RootViewController.h"

#import "UIView+QuickSizeFetcher.h"

#import "CarbonKit.h"

#import "UIColor+Bohr.h"

#import "Helper.h"

#import "APICommunicator.h"

#import "ViewComposer.h"

#import "DCUserDefaultKeyConstants.h"

@interface RootViewController ()<CarbonTabSwipeNavigationDelegate,UIAlertViewDelegate>{
    
    NSArray* barItems;
    
    CarbonTabSwipeNavigation* nav;
}

@property (weak, nonatomic) IBOutlet UIToolbar *swipeBar;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *likeBtn;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsBtn;


@end

@implementation RootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // init view controller components
    barItems = @[
                 [UIImage imageNamed:@"quick_decide.png"],
                 [UIImage imageNamed:@"decide_for_me.png"],
                 [UIImage imageNamed:@"decide_for_group.png"]
                 ];
    
    nav = [[CarbonTabSwipeNavigation alloc]initWithItems:barItems toolBar:_swipeBar delegate:self];
    
    [nav setSwipeEnabled:NO];
    
    [nav insertIntoRootViewController:self
                                             andTargetView:self.view];
    
    [_swipeBar.superview bringSubviewToFront:_swipeBar];
    
    [self setUp];
    
    // load the tutorial view
    if (![Helper hasShownWalkthrough]) {
        
       [[[ViewComposer sharedComposer]appTutorialViews]showInView:self.navigationController.view animateDuration:0.65];
        
        [Helper setUserDefault:kWALKTHROUGH_HAS_BEEN_DISPLAYED_KEY WithObject:@"yes"];
        
    }
    
}

-(void)setUp{
    
    BOOL hasLiked = [Helper getObjectFromUserDefaultWithName:@"liked"];
    
    if (hasLiked) {
        
        _likeBtn.image = [UIImage imageNamed:@"like_filled"];
        
    }else{
        
        _likeBtn.image = [UIImage imageNamed:@"like_unfilled"];
        
    }
    
    
    self.title = @"Quick Decide";
    
    UIColor *color = [UIColor bo_blueColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    nav.toolbar.translucent = NO;
    [nav setIndicatorColor:color];
    
    [nav.carbonSegmentedControl setWidth:[self.view getFrameWidth] / 3 forSegmentAtIndex:0];
    [nav.carbonSegmentedControl setWidth:[self.view getFrameWidth] / 3 forSegmentAtIndex:1];
    [nav.carbonSegmentedControl setWidth:[self.view getFrameWidth] / 3 forSegmentAtIndex:2];
    
    // Custimize segmented control
    [nav setNormalColor:[color colorWithAlphaComponent:0.6]
                                        font:[UIFont boldSystemFontOfSize:14]];
    [nav setSelectedColor:color
                                          font:[UIFont boldSystemFontOfSize:14]];

}



#pragma mark - Carbon Delegate

// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation
                                 viewControllerAtIndex:(NSUInteger)index {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    switch (index) {
        case 0:{
            return [storyboard instantiateViewControllerWithIdentifier:@"quickDecideVC"];
        }
        case 1:{
    
            return [storyboard instantiateViewControllerWithIdentifier:@"decideForMeVC"];
        }
        case 2: {
            return [storyboard instantiateViewControllerWithIdentifier:@"decideForGroupVC"];
        }
            
        default:
            
            return nil;
    }
}

// optional
- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                 willMoveAtIndex:(NSUInteger)index {
    switch(index) {
            
        case 0:
            self.title = @"Quick Decide";
            break;
        case 1:
            self.title = @"Decide For Me";
            break;
        case 2:
            self.title = @"Decide For Group";
            break;
        default:
            self.title = @"Quick Decide";
            break;
    }
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
    //NSLog(@"Did move at index: %ld", index);
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    
    return UIBarPositionTop;
}

#pragma mark - Actions

- (IBAction)tiggerLike:(id)sender {
    
    BOOL hasLiked = [[Helper getObjectFromUserDefaultWithName:@"liked"] boolValue];
    
    if (!hasLiked) {
        
        [Helper incrementLikeWithCompletionHandler:^(BOOL result){
           
            if (result) {
                
                // change the image
                _likeBtn.image = [UIImage imageNamed:@"like_filled"];
                
                // set settings
                [Helper setUserDefault:@"liked" WithObject:@(YES)];
                
            }
            
        }];
        
    }else{
        
        [self showLikeCount];
        
    }
    
}

- (void)showLikeCount {
    
    [[APICommunicator sharedCommunicator]sendRemoteCounterRequest:COUNTER_FETCH_LIKE_COUNTS CompletionHanlder:^(NSDictionary* result){
        
        NSString* message = result[@"message"];
        
        if (message) {
            
            UIAlertView* likeCountAlert = [[UIAlertView alloc]initWithTitle:@"The crowd" message:[NSString stringWithFormat:@"The app now has %@ likes. Join the crowd!",message] delegate:self cancelButtonTitle:@"Wow!" otherButtonTitles:@"Like again!", nil];
            
            likeCountAlert.tag = 0;
            
            [likeCountAlert show];
            
        }else{
            
            [Helper showErrorAlert];
            
        }

    }];
    
    
}

#pragma mark - UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 0) {
        
        if (buttonIndex == 1) {
            
            [Helper incrementLikeWithCompletionHandler:^(BOOL result){
                
                if (result) {
                    
                    [Helper showAlertWithTitle:@"Thank you!" Message:@"Your support is a great pleasure for us!" CancelButtonTitle:@"cool"];
                    
                }else{
                    
                    [Helper showErrorAlert];
                    
                }
                
            }];
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
