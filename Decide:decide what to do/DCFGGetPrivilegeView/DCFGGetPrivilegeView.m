//
//  DCFGGetPrivilegeView.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 27/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DCFGGetPrivilegeView.h"

#import "DCForGroupObject.h"

#import "Helper.h"

#import "UIView+QuickSizeFetcher.h"

#import "BSProgressButtonView.h"

#import "MFLTransformingScoreBoard.h"

#import "DCUserDefaultKeyConstants.h"
@interface DCFGGetPrivilegeView()<UIPickerViewDelegate,UIPickerViewDataSource,BSProgressButtonViewDelegate>{
    
    // the model
    DCForGroupObject* model;
    
    // data
    NSString* tmpTask;
    int extraChance;
    
    // role specific data
    NSArray* filteredTasks;
    
}
@property(strong,nonatomic)UIView* chooseTaskView;

@property(strong,nonatomic)UIView* getPrivilegePercentageView;

@end

@implementation DCFGGetPrivilegeView{
    
    // the picker
    UIPickerView* picker;
    
}

-(instancetype)initWithModel:(DCForGroupObject*)src andRole:(NSString *)roleName{
    
    if (self = [super init]) {
        
        // init views
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _chooseTaskView = [[UIView alloc]init];
        
        _chooseTaskView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _getPrivilegePercentageView = [[UIView alloc]init];
        
        _getPrivilegePercentageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // init model data
        model = src;
        
        RoleObject* selectedRole = [model findRoleWithName:roleName];
        
        NSMutableArray* newArray = [NSMutableArray arrayWithArray:model.tasks];
        
        NSLog(@"%@",model.tasks);
        
        for (NSString* task in model.tasks) {
            
            if ([[selectedRole retrieveTasksWithExtraChance] containsObject:task]) {
                
                [newArray removeObject:task];
                
            }
            
        }
        
        filteredTasks = [NSArray arrayWithArray:newArray];
        
        NSLog(@"FT: %@",filteredTasks);
        
        [self loadChooseTaskView];
        
    }
    
    return self;
    
}

#pragma mark - View loaders
-(void)loadChooseTaskView{
    // create an information title
    UILabel* info = [[UILabel alloc]init];
    
    info.translatesAutoresizingMaskIntoConstraints = NO;
    
    info.text = @"What does he/se want to do?\n Select one task!";
    
    info.textAlignment = NSTextAlignmentCenter;
    
    info.numberOfLines = 2;
    
    [_chooseTaskView addSubview:info];
    
    // create a custom picker ui to display the tasks that can be chosen
    picker = [[UIPickerView alloc]init];
    
    picker.translatesAutoresizingMaskIntoConstraints = NO;
    
    picker.dataSource = self;
    
    picker.delegate = self;
    
    [picker selectRow:filteredTasks.count/2 inComponent:0 animated:YES];
    
    [_chooseTaskView addSubview:picker];
    
    // create the continue button
    BSProgressButtonView* continueBtn = [[BSProgressButtonView alloc]init];

    continueBtn.text = @"Try some luck";
    
    continueBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    // init an UITapGesture recognizer and assign it to the button
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateFakeContinueButtonProgress:)];
    
    [continueBtn addGestureRecognizer:tapGesture];
    
    [_chooseTaskView addSubview:continueBtn];
    
    // add all to the root view
    [self addSubview:_chooseTaskView];
    
    // set up constraints
    NSDictionary* views = NSDictionaryOfVariableBindings(_chooseTaskView,info,picker,continueBtn);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_chooseTaskView]-(0)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_chooseTaskView]-(0)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    [self.chooseTaskView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(15)-[info]-(0)-[picker]-(0)-[continueBtn(==30)]-(25)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    [self.chooseTaskView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[info]-(15)-|" options:0 metrics:nil views:views]];
    
    [self.chooseTaskView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[continueBtn]-(15)-|" options:0 metrics:nil views:views]];
    
}

-(void)transitionToGetPrivilegePercentageViewWithTaskNamed:(NSString*)taskName{
    // do the transition
    // 1. shrink the chooseTaskView
    [UIView animateWithDuration:0.65
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void){
                         
                         // conceal the old view
                         _chooseTaskView.transform = CGAffineTransformMakeScale(0.75, 0.75);
                         
                         _chooseTaskView.alpha = 0;
        
    }
                     completion:^(BOOL finished){
                         
                         // init the original form (beform anime) of the new view
                         _getPrivilegePercentageView = [[UIView alloc]initWithFrame:CGRectMake(40, 40, [self getFrameWidth] - 80, [self getFrameHeight] - 80)];
                         
    }];
    
    // 2. expand the new view and add the stuff
    [UIView animateWithDuration:0.65
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         
                         // expand the interface of new view
                         _getPrivilegePercentageView.frame = self.frame;
                         
                         [self addSubview:_getPrivilegePercentageView];
                         
                         // add elements to the view
                         [self layoutPrivilegePercentageViewWithTaskNamed:taskName];
        
    }
                     completion:^(BOOL finished){
        
                         // Silence is Gold
    }];
    
    
}

// @fix: the layout for the following elements are so crappy...
-(void)layoutPrivilegePercentageViewWithTaskNamed:(NSString*)taskName{
    // congrats quote
    UILabel* congratualation = [[UILabel alloc]init];
    
    congratualation.textAlignment = NSTextAlignmentCenter;
    
    congratualation.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:20];
    
    congratualation.textColor = [UIColor grayColor];
    
    congratualation.translatesAutoresizingMaskIntoConstraints = NO;
    
    congratualation.text = @"More Chance!";
    
    [self addSubview:congratualation];
    
    // get random lucky percentage
    int calculatedPercentage = [model generateLuckyPercentage];
    
    // init transforming digit
    MFLTransformingScoreBoard* board = [[MFLTransformingScoreBoard alloc]initWithFrame:CGRectMake(0, 80, [_getPrivilegePercentageView getFrameWidth] / 1.6, [_getPrivilegePercentageView getFrameHeight] / 3)];
    
    MFLTransformingDigit *baseDigit = board.baseDigit;
    
    [baseDigit setLineThickness:8];
    
    [baseDigit setStrokeColor:[UIColor grayColor].CGColor];
    
    [board setBaseDigit:baseDigit];
    
    board.animationDuration = 1.5f;
    
    board.backgroundColor = [UIColor clearColor];
    
    [self addSubview:board];
    
    // add a percentage icon
    UILabel* percentage = [[UILabel alloc]initWithFrame:CGRectMake([board getFrameWidth], [board getBoundHeight], 30, 30)];
    
    percentage.alpha = 0;
    
    percentage.text = @"%";
    
    percentage.textAlignment = NSTextAlignmentCenter;
    
    percentage.textColor = [UIColor lightGrayColor];
    
    [self addSubview:percentage];
    
    // add some inspirational quote
    UILabel* inspiration = [[UILabel alloc]init];
    
    inspiration.textAlignment = NSTextAlignmentCenter;
    
    inspiration.alpha = 0;
    
    inspiration.numberOfLines = 2;
    
    inspiration.adjustsFontSizeToFitWidth = YES;
    
    inspiration.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular " size:10];

    inspiration.textColor = [UIColor grayColor];
    
    inspiration.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:inspiration];
    
    __weak DCFGGetPrivilegeView* weakSelf = self;
    
    // animate to result
    [board incrementByValue:calculatedPercentage completion:^(BOOL success){
        
        // load inspiration
        inspiration.text = [weakSelf inspirationalQuoteFromCalculatedResult:calculatedPercentage];
        
        // set chance
        extraChance = calculatedPercentage;
        
    }];
    
    
    // confirm/exit button
    UIButton* confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    confirmBtn.alpha = 0;
    
    confirmBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [confirmBtn setTitle:@"Okay" forState:UIControlStateNormal];
    
    [confirmBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [confirmBtn.layer setBorderWidth:2.0f];
    
    [confirmBtn.layer setCornerRadius:5.0f];
    
    [confirmBtn addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirmBtn setTintColor:[UIColor grayColor]];
    
    [self addSubview:confirmBtn];
    
    // add suppliment constraints
    NSDictionary* views = NSDictionaryOfVariableBindings(congratualation,board,inspiration,confirmBtn);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(25)-[congratualation(==20)]-(150)-[inspiration(==40)]-(30)-[confirmBtn]-(15)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(30)-[inspiration]-(30)-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(50)-[confirmBtn]-(50)-|" options:0 metrics:nil views:views]];
    
    // amimate in
    [UIView animateWithDuration:1.0f animations:^(void){
    
        percentage.alpha = 1;
        
        inspiration.alpha = 1;
        
        confirmBtn.alpha = 1;
        
    }];
    
}

#pragma mark - PickerView Delegate/Datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (filteredTasks.count == 0) {
        
        return 1;
        
    }
    
    return filteredTasks.count;
    
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (filteredTasks.count == 1) {
        
        return @"Hey! what more you want?";
        
    }
    
    return [filteredTasks objectAtIndex:row];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    tmpTask = [filteredTasks objectAtIndex:row];
    
}

-(void)saveSelectedTask{
    
    tmpTask = [filteredTasks objectAtIndex:[picker selectedRowInComponent:0]];
    
}

/*-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    
    
}*/

#pragma mark - private methods
-(void)updateFakeContinueButtonProgress:(UITapGestureRecognizer*)recognizer{
    
    // check if the right one tapped
    if ([recognizer.view isKindOfClass:[BSProgressButtonView class]]) {
        
        [self updateProgressForButtonView:(BSProgressButtonView*)recognizer.view];
        
        __weak DCFGGetPrivilegeView* weakSelf = self;
        
        for (int i = 1; i <= 4; i++) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.65 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf updateProgressForButtonView:(BSProgressButtonView*)recognizer.view];
                
            });

            
        }
        
    }
    
}

-(void)updateProgressForButtonView:(BSProgressButtonView*)buttonView{
    
    if (buttonView.progress < 1.0) {
        
        [buttonView updateProgress: buttonView.progress+0.25 withAnimation:YES];
        
        if (buttonView.progress == 1.0f) {
            // save data
            [self saveSelectedTask];
            
            // start transition
            [self transitionToGetPrivilegePercentageViewWithTaskNamed:[filteredTasks objectAtIndex:[picker selectedRowInComponent:0]]];
            
        }
        
    }
}

-(NSString*)inspirationalQuoteFromCalculatedResult:(int)result{
        
    // bad luck
    if ([Helper is:result inRangeBetween:1 and:20]) {
        
        return @"Well. It's alright.";
        
    }
    
    // good luck
    if ([Helper is:result inRangeBetween:20 and:40]) {
        
        return @"Great. Enjoy!";
        
    }
    
    
    // superior luck
    if ([Helper is:result inRangeBetween:40 and:51]) {
        
        return @"Yahoo! Don't blame anyone \nif you don't get to do it.";
        
    }
    
    return @"Tragedy.";
    
}

-(void)confirmBtnPressed:(id)sender{
    
    // set tag for view composer to pick up
    self.tag = 2;
    
    NSDictionary* data = @{_roleName:@{
                                   tmpTask: [NSNumber numberWithInt:extraChance]
                                   },
                           @"sender":(id)self
                           };
    
    [_delegate viewDidFinishRetrievingPrivilegeData:data];
    
    // post notification for now
    [[NSNotificationCenter defaultCenter]postNotificationName:kDFG_DID_FINISH_GET_PRIVILEGE_NOTIFICATION_KEY object:nil userInfo:data];
    
}


@end
