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

@interface RootViewController ()<CarbonTabSwipeNavigationDelegate>{
    
    NSArray* barItems;
    
    CarbonTabSwipeNavigation* nav;
}

@property (weak, nonatomic) IBOutlet UIToolbar *swipeBar;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // init carbonkit components
    barItems = @[
                 [UIImage imageNamed:@"quick_decide.png"],
                 [UIImage imageNamed:@"decide_for_me.png"],
                 [UIImage imageNamed:@"decide_for_group.png"]
                 ];
    
    nav = [[CarbonTabSwipeNavigation alloc]initWithItems:barItems toolBar:_swipeBar delegate:self];
    
    [nav insertIntoRootViewController:self
                                             andTargetView:self.view];
    
    [_swipeBar.superview bringSubviewToFront:_swipeBar];
    
    [self setUp];
    
}

-(void)setUp{
    
    self.title = @"Quick Decide";
    
    UIColor *color = [UIColor colorWithRed:24.0/255 green:75.0/255 blue:152.0/255 alpha:1];
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

#pragma mark - Nav Delegate

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
