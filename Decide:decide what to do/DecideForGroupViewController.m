//
//  DeicdeForGroupViewController.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 8/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <objc/runtime.h>

#import "DecideForGroupViewController.h"

#import "DCForGroupObject.h"

#import "DFGRoleTableViewCell.h"

#import "DFGTaskTableViewCell.h"

#import "UIView+QuickSizeFetcher.h"

#import "Helper.h"

#import "ViewComposer.h"

#import "DCUserDefaultKeyConstants.h"

#import "DCFGGetPrivilegeView.h"

#import "KLCPopup.h"

#import "M13ProgressHUD.h"

#import "M13ProgressViewRing.h"
static char kBtnReceiverKey;


@interface DecideForGroupViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    DCForGroupObject* model;
    
}

@property (strong,nonatomic) UITableView* rolesTableView;

@property (strong,nonatomic) UITableView* tasksTableView;

@property (strong,nonatomic) UIButton* decideBtn;

@property (strong,nonatomic) UIButton* resetBtn;

@end

@implementation DecideForGroupViewController

-(void)viewWillAppear:(BOOL)animated{
    
    //...
    
}


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    // add notification observer to listen to [add privilege] events
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveAddPrivilegeActionFromNotificationCenter:) name:kDFG_PRESENT_ADD_PRIVILEGE_POPUP_NOTIFICATION_KEY object:nil];
    
    // add notification observer to listen to [finish add privilege] events
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didFinishAddingPrivilegeFromNotificationCenter:) name:kDFG_DID_FINISH_GET_PRIVILEGE_NOTIFICATION_KEY object:nil];
    
    // add observer to listen to [decision view dismissed] event
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableViewData) name:kDFG_DECISION_RESULT_VIEW_DISMISSED object:nil];
    
    //@weird: remove headers/footers
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // initialize the model object
    model = [[DCForGroupObject alloc]initWithRoleList:@[@"Dad",@"Mum",@"Kid"] AndTasks:@[@"Wash",@"Clean",@"Sweep"]];
    
    UIView* tableViewsContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self.view getFrameWidth], [self.view getFrameHeight] / 2)];
    
    // Add Roles TableView
    _rolesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [self.view getFrameWidth] / 2, [self.view getFrameHeight] / 2) style:UITableViewStylePlain];

    _rolesTableView.delegate = self;
    
    _rolesTableView.dataSource = self;
    
    _rolesTableView.tag = 1;
    
    [tableViewsContainer addSubview:_rolesTableView];
    
    // Add Tasks TableView
    _tasksTableView = [[UITableView alloc]initWithFrame:CGRectMake([tableViewsContainer getFrameWidth] / 2, 0, [self.view getFrameWidth] / 2, [self.view getFrameHeight] / 2) style:UITableViewStylePlain];
    
    _tasksTableView.delegate = self;
    
    _tasksTableView.dataSource = self;
    
    _tasksTableView.tag = 2;
    
    [tableViewsContainer addSubview:_tasksTableView];
    
    // Add separator
    UIView* separatorView = [[ViewComposer sharedComposer]composeSeparatorViewWithFrame:CGRectMake([tableViewsContainer getFrameWidth] / 2 - 1, 20, 2, [tableViewsContainer getFrameHeight]- 20) Color:[UIColor lightGrayColor]];
    
    [tableViewsContainer addSubview:separatorView];
    
    [self.view addSubview:tableViewsContainer];
    
    // Add decide and reset btn
    _decideBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [_decideBtn.titleLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:30]];
    _decideBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    _decideBtn.layer.cornerRadius = 50;
    
    _decideBtn.layer.borderWidth = 1.0f;
    
    _decideBtn.layer.borderColor = _decideBtn.titleLabel.textColor.CGColor;
    
    [_decideBtn addTarget:self action:@selector(decideBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_decideBtn setTitle:@"Decide Now!" forState:UIControlStateNormal];
    
    _resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _resetBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_resetBtn setTitle:@"Reset" forState:UIControlStateNormal];
    
    [_resetBtn addTarget:self action:@selector(resetBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_decideBtn];
    
    [self.view addSubview:_resetBtn];
    
    NSDictionary* buttonViews = NSDictionaryOfVariableBindings(tableViewsContainer,_decideBtn,_resetBtn);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tableViewsContainer]-(30)-[_decideBtn]-(40)-[_resetBtn]-(30)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:buttonViews]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(60)-[_decideBtn]-(60)-|" options:0 metrics:nil views:buttonViews]];
    
}

#pragma mark - UITableView Delegate
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (tableView.tag == 1) {
            
            // remove the role in database
            [model removeRole:[model.roles objectAtIndex:indexPath.row].name];
            
            // delete the row UI
            [self deleteRowAtIndexPath:indexPath OnTableView:_rolesTableView];
            
        }
        
        if (tableView.tag == 2) {
            
            // remove the task in database
            [model removeTask:[model.tasks objectAtIndex:indexPath.row]];
            
            // delete the row UI
            [self deleteRowAtIndexPath:indexPath OnTableView:_tasksTableView];
            
        }
        
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // Roles table view
    if (tableView.tag == 1) {
        
        return model.roles.count;
        
    }
    
    // Tasks table view
    if (tableView.tag == 2) {
        
        return model.tasks.count;
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // roles table
    if (tableView.tag == 1) {
        
        static NSString* identifier = @"role_cell";
        
        DFGRoleTableViewCell* cell = (DFGRoleTableViewCell*)[_rolesTableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            
            cell = [[DFGRoleTableViewCell alloc]init];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.roleName.text = model.roles[indexPath.row].name;
        
        return cell;
        
    }
    
    // tasks table
    if (tableView.tag == 2) {
        
        static NSString* identifier = @"task_cell";
        
        DFGTaskTableViewCell* cell = (DFGTaskTableViewCell*)[_tasksTableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            
            cell = [[DFGTaskTableViewCell alloc]init];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.taskName.text = model.tasks[indexPath.row];
        
        return cell;
        
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    // Roles table view
    if (tableView.tag == 1) {
        
        UIView* roleFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [tableView getFrameWidth], 50)];
        
        roleFooterView.backgroundColor = [UIColor whiteColor];
        
        UIButton* addRoleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        addRoleBtn.tintColor = [UIColor grayColor];
        
        [addRoleBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 20)];
        
        [addRoleBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        
        [addRoleBtn.layer setBorderWidth:2.0f];
        
        [addRoleBtn.layer setCornerRadius:5.0f];
        
        addRoleBtn.frame = CGRectMake(20, 10, [roleFooterView getFrameWidth] - 40, [roleFooterView getFrameHeight]-20);
        
        [addRoleBtn setTitle:@"New Player" forState:UIControlStateNormal];
        
        objc_setAssociatedObject(addRoleBtn, &kBtnReceiverKey, @"trigger_addRole", OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        [addRoleBtn addTarget:self action:@selector(receiveActionFromButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [roleFooterView addSubview:addRoleBtn];
        
        return roleFooterView;
        
    }else
    // tasks tableview
    if (tableView.tag == 2){
        
            UIView* taskFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [tableView getFrameWidth], 50)];
            
            taskFooterView.backgroundColor = [UIColor whiteColor];
            
            UIButton* addTaskBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            
            addTaskBtn.tintColor = [UIColor grayColor];
            
            [addTaskBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 20)];
            
            [addTaskBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            
            [addTaskBtn.layer setBorderWidth:2.0f];
            
            [addTaskBtn.layer setCornerRadius:5.0f];
            
            addTaskBtn.frame = CGRectMake(20, 10, [taskFooterView getFrameWidth] - 40, [taskFooterView getFrameHeight]-20);
            
            [addTaskBtn setTitle:@"New Task" forState:UIControlStateNormal];
            
            objc_setAssociatedObject(addTaskBtn, &kBtnReceiverKey, @"trigger_addTask", OBJC_ASSOCIATION_COPY_NONATOMIC);
            
            [addTaskBtn addTarget:self action:@selector(receiveActionFromButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [taskFooterView addSubview:addTaskBtn];
            
            return taskFooterView;

        
    }
    
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    // Roles table view
    if (tableView.tag == 1) {
        
        UIView* roleHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [tableView getFrameWidth], 50)];
        
        roleHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel* roleTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [roleHeaderView getFrameWidth], [roleHeaderView getFrameHeight])];
        
        roleTitleLabel.text = @"Participants";
        
        roleTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        roleTitleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo" size:30];
        
        [roleHeaderView addSubview:roleTitleLabel];
        
        UIView* separatorView = [[ViewComposer sharedComposer]composeSeparatorViewWithFrame:CGRectMake(15, 48 , [tableView getFrameWidth] - 30, 2)
                                                                                    BgColor:[UIColor lightGrayColor] ColorTransition:@[
                                                                                                                                       (id)[UIColor clearColor].CGColor,                                                                                  (id)[UIColor lightGrayColor].CGColor,(id)[UIColor lightGrayColor].CGColor,(id)[UIColor clearColor].CGColor
                                                                                                                                       ]
                                                                                     Config:@{
                                                          @"locations":@[@(0.0f),@(0.2f),@(0.8f),@(1.0f)],
                                                          @"start_point":[NSValue valueWithCGPoint:CGPointMake(0.0f, 0.5f)],
                                                          @"end_point":
                                                        [NSValue valueWithCGPoint:CGPointMake(1.0f, 0.5f)]
                                         
                                        }];
        
        [roleHeaderView addSubview:separatorView];
        
        return roleHeaderView;
        
    }
    
    // Tasks table view
    if (tableView.tag == 2) {
        
        UIView* taskHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [tableView getFrameWidth], 50)];
        
        taskHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel* taskTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [taskHeaderView getFrameWidth], [taskHeaderView getFrameHeight])];
        
        taskTitleLabel.text = @"Tasks";
        
        taskTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        taskTitleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo" size:30];
        
        [taskHeaderView addSubview:taskTitleLabel];
        
        UIView* separatorView = [[ViewComposer sharedComposer]composeSeparatorViewWithFrame:CGRectMake(15, 48 , [tableView getFrameWidth] - 30, 2)
                                                                                    BgColor:[UIColor lightGrayColor] ColorTransition:@[
                                                                                                                                       (id)[UIColor clearColor].CGColor,                                                                                  (id)[UIColor lightGrayColor].CGColor,(id)[UIColor lightGrayColor].CGColor,(id)[UIColor clearColor].CGColor
                                                                                                                                       ]
                                                                                     Config:@{
                                                                                              @"locations":@[@(0.0f),@(0.2f),@(0.8f),@(1.0f)],
                                                                                              @"start_point":[NSValue valueWithCGPoint:CGPointMake(0.0f, 0.5f)],
                                                                                              @"end_point":
                                                                                                  [NSValue valueWithCGPoint:CGPointMake(1.0f, 0.5f)]
                                                                                              }];
        [taskHeaderView addSubview:separatorView];
        
        return taskHeaderView;
        
    }

    
    return nil;
    
}

#pragma mark - Actions

-(void)receiveActionFromButton:(id)sender{
    
    NSString* associatedValue = objc_getAssociatedObject(sender, &kBtnReceiverKey);
    
    if ([associatedValue isEqualToString:@"trigger_addRole"]) {
        
        // add role btn pressed
        [self presentPopupWithType:POPUP_ADD_NEW_ROLE];
    }
    
    if ([associatedValue isEqualToString:@"trigger_addTask"]) {
        
        // add task btn pressed
        [self presentPopupWithType:POPUP_ADD_NEW_TASK];
        
    }

}

-(void)presentPopupWithType:(POPUP_TYPE)type{
    
    // get the view ready
    UIView* contentView = [[UIView alloc]init];
    
    switch (type) {
            
        case POPUP_ADD_NEW_ROLE:{
            
            contentView = [[ViewComposer sharedComposer]composeDecideForGroupAddNewRolePopupWithTarget:self andSelector:@selector(viewComposerBtnPressed:)];
            
        }
            break;
         
        case POPUP_ADD_NEW_TASK:{
            
            contentView = [[ViewComposer sharedComposer]composeDecideForGroupAddNewTaskPopupWithTarget:self andSelector:@selector(viewComposerBtnPressed:)];
            
        }
            break;
            
        default:
            
            break;
            
    }
    
    // get the wrapper ready
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    [popup show];
    
}

-(void)presentAddPrivilegePopupWithParticipantName:(NSString*)name{
    
    // compose the container view
    UIView* contentView = [[ViewComposer sharedComposer]composeDecideForGroupAddPrivilegePopupWithParticipantName:name model:model target:self andSelector:@selector(viewComposerBtnPressed:)];
    
    // get the wrapper ready
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeFadeOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    [popup show];
    
}

-(void)decideBtnPressed:(id)sender{
    
    // validation
    if (model.tasks.count == 0 || model.roles.count == 0) {
        
        [[[UIAlertView alloc]
          initWithTitle:@"Whatcha you doing!" message:@"Make up your mind first!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil]
         show];
        
    }else{
        
        // @todo: present a grand popup with the result
        // add a fake processing HUD to illustrating the sense of invocation.
        
        M13ProgressHUD* fakeHUD = [[M13ProgressHUD alloc]initWithProgressView:[[M13ProgressViewRing alloc]init]];
        
        fakeHUD.status = @"Intense Calculation...";
        
        fakeHUD.progressViewSize = CGSizeMake(60.0, 60.0);
        
        __weak M13ProgressHUD* weakFakeHUD = fakeHUD;
        
        __weak DecideForGroupViewController* weakSelf = self;
        
        [fakeHUD setCompletionBlock:^{
            
            [weakFakeHUD hide:YES];
            
            // load the view
            [weakSelf showDecisionResultPopup];
            
        }];
        
        fakeHUD.animationPoint = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
        
        [self.view addSubview:fakeHUD];
        
        [fakeHUD show:YES];
        
        for (int i = 1; i < 5; i ++) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.65 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [fakeHUD setProgress:0.25 * i animated:YES];
                
            });
            
        }
        
        
    }
    
}


-(void)resetBtnPressed:(id)sender{
    
    // reset the model database
    [model reset];
    
    // reload tableviews with animation
    [self updateTableViewsAnimated:YES];
}

#pragma mark - Private methods
-(void)showDecisionResultPopup{
    
    // get roles model after the decision
    NSArray<RoleObject*>* decidedResult = [model decideWithRandomPriority];
    
    UIView* contentView = [[ViewComposer sharedComposer]composeDecideForGroupShowDecisionResultPopupWithResultDataSet:decidedResult];
    
    KLCPopup* popup = [KLCPopup popupWithContentView:contentView showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    
    [popup show];
    
}

-(void)reloadTableViewData{
    
    [model reloadData];
    
    [_rolesTableView reloadData];
    
    [_tasksTableView reloadData];
    
}

-(void)viewComposerBtnPressed:(id)sender{
    
    if ([sender isKindOfClass:[UIView class]]) {
        
        [(UIView*)sender dismissPresentingPopup];
        
    }
    
    switch ([sender tag]) {
            
        case POPUP_ADD_NEW_ROLE:{
            
            // get the data and add to database
            NSString* newRole = [[ViewComposer sharedComposer]getCurrentEditingTextFieldText];
            
            if ([newRole isEqualToString:@""]) {
                
                [[[UIAlertView alloc]initWithTitle:@"A non existing name?" message:@"What were you doing?" delegate:self cancelButtonTitle:@"Let me try again" otherButtonTitles:nil, nil]show];
                
            }else{
                
                [model addRole:newRole];
                
                // refresh tableview
                [self insertRowAtIndexPath:[NSIndexPath indexPathForRow:model.roles.count - 1 inSection:0] OnTableView:_rolesTableView];
                
            }
            
           
            
        }
            break;
        case POPUP_ADD_NEW_TASK:{
            
            // get the data and add to database
            NSString* newTask = [[ViewComposer sharedComposer]getCurrentEditingTextFieldText];
            
            if ([newTask isEqualToString:@""]) {
                
                [[[UIAlertView alloc]initWithTitle:@"A non existing task?" message:@"What were you doing?" delegate:self cancelButtonTitle:@"Let me try again" otherButtonTitles:nil, nil]show];
                
            }else{
                
                [model addTask:newTask];
                
                // refresh tableview
                [self insertRowAtIndexPath:[NSIndexPath indexPathForRow:model.tasks.count - 1 inSection:0] OnTableView:_tasksTableView];
                
            }
            
            
        }
            break;
            
        case POPUP_ADD_PRIVILEGE:{
            
            if ([sender isKindOfClass:[DCFGGetPrivilegeView class]]) {
                // retrieve role name
                NSString* roleName = [(DCFGGetPrivilegeView*)sender roleName];
                
                DFGRoleTableViewCell* cell = [_rolesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[model indexOfRoleWithName:roleName] inSection:0]];
                
                [cell.addPrivilegeBtn setImage:[UIImage imageNamed:@"vip_assigned.png"] forState:UIControlStateNormal];
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
}


-(void)updateTableViewsAnimated:(BOOL)animated{
    
    if (animated) {
        
        [_rolesTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        [_tasksTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
    }else{
        
        [_rolesTableView reloadData];
        
        [_tasksTableView reloadData];
    }
}

-(void)insertRowAtIndexPath:(NSIndexPath*)indexPath OnTableView:(UITableView*)tableview{
    
    [tableview beginUpdates];
    
    [tableview insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [tableview endUpdates];
    
}

-(void)deleteRowAtIndexPath:(NSIndexPath*)indexPath OnTableView:(UITableView*)tableview{
    
    [tableview beginUpdates];
    
    [tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [tableview endUpdates];
}

#pragma mark - Notification handlers
-(void)receiveAddPrivilegeActionFromNotificationCenter:(NSNotification*)notification{
    
    NSString* roleName = notification.userInfo[@"role_name"];
    
    if ([model isAlreadyVIPForRoleWithName:roleName]) {
        
        [[[UIAlertView alloc]initWithTitle:@"Hey" message:@"Sorry, you are already the lucky one!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Upgrade assets", nil] show];
        
    }else{
        
        // add privilege btn pressed
        [self presentAddPrivilegePopupWithParticipantName:roleName];

        
    }
    
   
    
}

-(void)didFinishAddingPrivilegeFromNotificationCenter:(NSNotification*)notification{
    
    // grab the data
    NSDictionary* privilegeData = notification.userInfo;
    
    // extract the data
    NSString* role_name = privilegeData.allKeys[0];
    NSString* task_name = [privilegeData[role_name] allKeys][0];
    int extraChance = [privilegeData[role_name][task_name] intValue];
    
    // assign to role
    [model assignExtraChance:extraChance OfDoingTaskNamed:task_name ToRoleWithName:role_name];
    
    // dismiss the view
    [self viewComposerBtnPressed:(id)privilegeData[@"sender"]];
    
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

@end
