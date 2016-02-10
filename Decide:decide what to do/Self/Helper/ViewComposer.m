//
//  ViewComposer.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 22/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "ViewComposer.h"

#import "DecideForMeViewController.h"

#import "DCUserDefaultKeyConstants.h"

#import "DCFMTextField.h"

#import "Helper.h"

#import "DCForGroupObject.h"

#import "RoleObject.h"

#import "DCFGGetPrivilegeView.h"

#import "DCFGResultView.h"

#import "IntroRegistrationView.h"

@interface ViewComposer()<DCFMTextFieldDelegate>{
    
    NSString* currentEditingText;
    
    NSDictionary* retrievedPrivilegeData;
    
}

@end

@implementation ViewComposer

+(instancetype)sharedComposer{
    
    static ViewComposer* composer = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^(void){
       
        composer = [[self alloc]init];
        
        
    });
    
    return composer;
    
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        currentEditingText = [[NSString alloc]init];
        
    }
    
    return self;
}

#pragma mark - view generators

-(UIView*)composeQuickDecisionPopupWithResult:(BOOL)result actionTarget:(id)target andSelector:(SEL) sel{
    
    NSString* resultString = [[NSString alloc]init];
    
    NSString* promptString = [[NSString alloc]init];
    
    if (result) {
        
        resultString = @"YES";
        
        promptString = @"Great!!";
        
    }else{
        
        resultString = @"NO";
        
        promptString = @"Alright..";
        
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
    [dismissButton setTitle:promptString forState:UIControlStateNormal];
    dismissButton.layer.cornerRadius = 6.0;
    [dismissButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
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

-(UIView*)composeDecideForMeCreatingNewTaskPopupWithActionTarget:(id)target andSelector:(SEL)sel{
    
    // Generate content view to present
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor colorWithRed:(184.0/255.0) green:(233.0/255.0) blue:(122.0/255.0) alpha:1.0];
    contentView.layer.cornerRadius = 12.0;
    
    UILabel* confirmLabel = [[UILabel alloc] init];
    confirmLabel.translatesAutoresizingMaskIntoConstraints = NO;
    confirmLabel.backgroundColor = [UIColor clearColor];
    confirmLabel.textColor = [UIColor whiteColor];
    confirmLabel.font = [UIFont boldSystemFontOfSize:42.0];
    confirmLabel.text = @"New Task";
    
    DCFMTextField* textField = [[DCFMTextField alloc]initWithRound:YES tintHex:nil placeholder:@"Enter a new name"];
    
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    
    textField.delegate = self;
    
    [contentView addSubview:textField];
    
    UIButton* confirmTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmTaskBtn.translatesAutoresizingMaskIntoConstraints = NO;
    confirmTaskBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    confirmTaskBtn.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(204.0/255.0) blue:(134.0/255.0) alpha:1.0];
    [confirmTaskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmTaskBtn setTitleColor:[[confirmTaskBtn titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    confirmTaskBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [confirmTaskBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    confirmTaskBtn.layer.cornerRadius = 6.0;
    [confirmTaskBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:confirmLabel];
    [contentView addSubview:confirmTaskBtn];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(textField,confirmTaskBtn, confirmLabel);
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(16)-[confirmLabel]-(15)-[textField]-(15)-[confirmTaskBtn]-(24)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(36)-[confirmLabel]-(36)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[textField]-(10)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    return contentView;

    
}

-(UIView*)composeDecideForMeShowDecisionPopupWithResult:(NSString *)result target:(id)target andSelector:(SEL)sel{
    
    // Generate content view to present
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor colorWithRed:(184.0/255.0) green:(233.0/255.0) blue:(122.0/255.0) alpha:1.0];
    contentView.layer.cornerRadius = 12.0;
    
    UILabel* resultLabel = [[UILabel alloc] init];
    resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    resultLabel.backgroundColor = [UIColor clearColor];
    resultLabel.textColor = [UIColor whiteColor];
    resultLabel.font = [UIFont boldSystemFontOfSize:24.0];
    resultLabel.text = result;
    
    UIButton* dismissResultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissResultBtn.translatesAutoresizingMaskIntoConstraints = NO;
    dismissResultBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    dismissResultBtn.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(204.0/255.0) blue:(134.0/255.0) alpha:1.0];
    [dismissResultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dismissResultBtn setTitleColor:[[dismissResultBtn titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    dismissResultBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [dismissResultBtn setTitle:@"Okay" forState:UIControlStateNormal];
    dismissResultBtn.layer.cornerRadius = 6.0;
    [dismissResultBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:resultLabel];
    [contentView addSubview:dismissResultBtn];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(dismissResultBtn, resultLabel);
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(16)-[resultLabel]-(20)-[dismissResultBtn]-(24)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(36)-[resultLabel]-(36)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    return contentView;
    
}

-(UIView*)composeDecideForGroupAddNewRolePopupWithTarget:(id)target andSelector:(SEL)sel{
    
    // Generate content view to present
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor colorWithRed:(184.0/255.0) green:(233.0/255.0) blue:(122.0/255.0) alpha:1.0];
    contentView.layer.cornerRadius = 12.0;
    
    UILabel* infoLabel = [[UILabel alloc] init];
    infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = [UIFont boldSystemFontOfSize:35.0];
    infoLabel.text = @"New Participant";
    
    UIButton* addRoleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addRoleBtn.translatesAutoresizingMaskIntoConstraints = NO;
    addRoleBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    addRoleBtn.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(204.0/255.0) blue:(134.0/255.0) alpha:1.0];
    [addRoleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addRoleBtn setTitleColor:[[addRoleBtn titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    addRoleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [addRoleBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    addRoleBtn.layer.cornerRadius = 6.0;
    [addRoleBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [addRoleBtn setTag:POPUP_ADD_NEW_ROLE];
    
    [contentView addSubview:infoLabel];
    [contentView addSubview:addRoleBtn];
    
    DCFMTextField* textField = [[DCFMTextField alloc]initWithRound:YES tintHex:nil placeholder:@"Enter a new name"];
    
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    
    textField.delegate = self;
    
    [contentView addSubview:textField];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(addRoleBtn, infoLabel,textField);
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(16)-[infoLabel]-(15)-[textField]-(15)-[addRoleBtn]-(24)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[textField]-(10)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(36)-[infoLabel]-(36)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    
    [contentView addSubview:textField];
    
    return contentView;

}

-(UIView*)composeDecideForGroupAddNewTaskPopupWithTarget:(id)target andSelector:(SEL)sel{
    
    // Generate content view to present
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor colorWithRed:(184.0/255.0) green:(233.0/255.0) blue:(122.0/255.0) alpha:1.0];
    contentView.layer.cornerRadius = 12.0;
    
    UILabel* infoLabel = [[UILabel alloc] init];
    infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = [UIFont boldSystemFontOfSize:42.0];
    infoLabel.text = @"New Task";
    
    UIButton* addTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addTaskBtn.translatesAutoresizingMaskIntoConstraints = NO;
    addTaskBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    addTaskBtn.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(204.0/255.0) blue:(134.0/255.0) alpha:1.0];
    [addTaskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addTaskBtn setTitleColor:[[addTaskBtn titleColorForState:UIControlStateNormal] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    addTaskBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [addTaskBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    addTaskBtn.layer.cornerRadius = 6.0;
    [addTaskBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [addTaskBtn setTag:POPUP_ADD_NEW_TASK];
    
    [contentView addSubview:infoLabel];
    [contentView addSubview:addTaskBtn];
    
    DCFMTextField* textField = [[DCFMTextField alloc]initWithRound:YES tintHex:nil placeholder:@"Enter A Task"];
    
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    
    textField.delegate = self;
    
    [contentView addSubview:textField];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(addTaskBtn, infoLabel,textField);
    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(16)-[infoLabel]-(15)-[textField]-(15)-[addTaskBtn]-(24)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[textField]-(10)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    

    
    [contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(36)-[infoLabel]-(36)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    
    
    
    return contentView;
}

-(UIView*)composeDecideForGroupAddPrivilegePopupWithParticipantName:(NSString *)name model:(DCForGroupObject*)model target:(id)target andSelector:(SEL)sel{
    
    // generate contentview to present
    UIView* contentView = [[UIView alloc]init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 12.0f;
    
    // load the custom view
    DCFGGetPrivilegeView* innerView = [[DCFGGetPrivilegeView alloc]initWithModel:model andRole:name];
    
    innerView.roleName = name;

    [contentView addSubview:innerView];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(contentView,innerView);
    
    // add constraints
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[innerView]-(0)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[innerView]-(0)-|" options:0 metrics:nil views:views]];
    
    // @fix: it appears that there is no need to require the selector and the target
    
    return contentView;
    
}

-(UIView*)composeDecideForGroupShowDecisionResultPopupWithResultDataSet:(NSArray<RoleObject *> *)data{
    
    UIView* contentView = [[UIView alloc]init];
    
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    DCFGResultView* resultView = [[DCFGResultView alloc]initWithData:data];
    
    resultView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [contentView addSubview:resultView];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(resultView,contentView);
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[resultView(==300)]-(0)-|" options:0 metrics:nil views:views]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[resultView(==400)]-(0)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    return contentView;
    
}

-(UIView*)composeSeparatorViewWithFrame:(CGRect)frame Color:(UIColor *)color{
    
    UIView* separatorView = [[UIView alloc]initWithFrame:frame];
    
    separatorView.backgroundColor = color;
    
    return separatorView;
    
}

-(UIView*)composeSeparatorViewWithFrame:(CGRect)frame BgColor:(UIColor*)color ColorTransition:(NSArray *)transitions Config:(NSDictionary *)configs{
    
    UIView* separatorView = [self composeSeparatorViewWithFrame:frame Color:color];
    
    CAGradientLayer* gradient = [CAGradientLayer layer];
    
    gradient.frame = separatorView.bounds;
    
    gradient.colors = transitions;
    
    gradient.locations = configs[@"locations"];
    
    gradient.startPoint = [(NSValue*)configs[@"start_point"] CGPointValue];
    
    gradient.endPoint = [(NSValue*)configs[@"end_point"] CGPointValue];
    
    [separatorView.layer setMask:gradient];
    
    return separatorView;
}

-(EAIntroView*)appTutorialViews{
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"decide_what_to_do_intro_pg1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"decide_what_to_do_intro_pg2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"decide_what_to_do_intro_pg3"];
    
    //@todo: another custom view with the signing in button
    EAIntroPage *page4 = [EAIntroPage pageWithCustomView:[[IntroRegistrationView alloc]init]];
    
    EAIntroView* tutView = [[EAIntroView alloc]initWithFrame:[[[UIApplication sharedApplication]delegate]window].frame andPages:@[page1,page2,page3,page4]];
    
    [tutView setPageControl:nil];
    
    return tutView;
    
}

#pragma mark - delegates
// @caution: this will only allow one textfield editing
// at one time, if more, delegate will receive multiple
// inputs
-(void)textFieldDidFinishEditingWithInput:(NSString *)text{

    currentEditingText = text;
    
}
#pragma mark - private methods


#pragma mark - public methods
-(NSString*)getCurrentEditingTextFieldText{
    
    NSString* result = [currentEditingText copy];
    
    currentEditingText = @"";
    
    return result;
    
}
@end
