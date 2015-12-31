//
//  DecideForMeViewController.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 8/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//
#import "DecideForMeViewController.h"

#import "DCForMeObject.h"

#import "DFMTableViewCell.h"

#import "DCFMTextField.h"

#import "DFMAddTaskTableViewCell.h"

#import "UIView+QuickSizeFetcher.h"

#import "Helper.h"

#import "ViewComposer.h"

#import "KLCPopup.h"

#import "DCUserDefaultKeyConstants.h"

@interface DecideForMeViewController()<UITableViewDelegate,UITableViewDataSource>{
    
    DCForMeObject* model;
        
    NSString* tmpOutcome;
    
}

@property (strong, nonatomic) UITableView *taskListTableView;

@property (strong,nonatomic) UIButton* decideBtn;

@property (strong,nonatomic) UIButton* resetBtn;

@end

@implementation DecideForMeViewController

-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    // ...
    
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    // init decide for me object
    model = [[DCForMeObject alloc]initWithActivityList:@[@"Eating",@"Drinking"]];
    
    
    // add tableview
    _taskListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [self.view getFrameWidth], [self.view getFrameHeight] / 2) style:UITableViewStylePlain];
    
    _taskListTableView.delegate = self;
    
    _taskListTableView.dataSource = self;
    
    [_taskListTableView.layer setShadowColor:[[UIColor grayColor] CGColor]];
    [_taskListTableView.layer setShadowOffset:CGSizeMake(0, 0)];
    
    [_taskListTableView.layer setShadowRadius:5.0];
    
    [_taskListTableView.layer setShadowOpacity:1];
    
    [_taskListTableView setBackgroundColor:[Helper colorFromHex:@"#e1f5fe"]];
    
    [self.view addSubview:_taskListTableView];
    
    // add footer to remove extra lines
    [self addFooter];
    
    [_taskListTableView registerClass:[DFMAddTaskTableViewCell class] forCellReuseIdentifier:@"add_cell"];
    
    [_taskListTableView registerClass:[DFMTableViewCell class] forCellReuseIdentifier:@"normal_cell"];
    
    // add notification observer for adding new tasks
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentAddNewTaskPopup) name:kDFM_ADD_NEW_TASK_NOTIFICATION_KEY object:nil];
    
    // add decideBtn
    _decideBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [_decideBtn.titleLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:30]];
    _decideBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    _decideBtn.layer.cornerRadius = 50;
    
    _decideBtn.layer.borderWidth = 1.0f;
    
    _decideBtn.layer.borderColor = _decideBtn.titleLabel.textColor.CGColor;
    
    [_decideBtn addTarget:self action:@selector(decideBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_decideBtn setTitle:@"Decide Now!" forState:UIControlStateNormal];
    
    // add reset button
    _resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _resetBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_resetBtn setTitle:@"Reset" forState:UIControlStateNormal];
    
    [_resetBtn addTarget:self action:@selector(resetBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_decideBtn];
    
    [self.view addSubview:_resetBtn];
    
    NSDictionary* buttonViews = NSDictionaryOfVariableBindings(_taskListTableView,_decideBtn,_resetBtn);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_taskListTableView]-(50)-[_decideBtn]-(40)-[_resetBtn]-(64)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:buttonViews]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(60)-[_decideBtn]-(60)-|" options:0 metrics:nil views:buttonViews]];
    
}


#pragma mark - TableView DataSource / Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger count = [model getListOfActivities].count;
    
    if (count == 0) {
        
        return 1;
        
    }
    
    return count + 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // if add new task cell
    if (indexPath.row == [model getListOfActivities].count) {
        
        return 60;
        
    }
    
    return 45;
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row != [model getListOfActivities].count) {
        
        return YES;
 
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [model removeActivity:[[model getListOfActivities] objectAtIndex:indexPath.row]];
        
        [self deleteRowAtIndexPath:indexPath];
        
    }
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // if the row is at end -> queue add task cell
    if (indexPath.row == ([model getListOfActivities].count)) {
        
        static NSString* identifier = @"add_cell";
        
        DFMAddTaskTableViewCell* cell = (DFMAddTaskTableViewCell*)[_taskListTableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            
            cell = [[DFMAddTaskTableViewCell alloc]init];
        
        }
        
        
        return cell;
        
    }else{
        
        static NSString* identifier = @"normal_cell";

        // normal rows
        
        DFMTableViewCell* cell = (DFMTableViewCell*)[_taskListTableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            
            cell = [[DFMTableViewCell alloc]init];
            
        }
        
        NSString* celltext = [[model getListOfActivities] objectAtIndex:indexPath.row];
        
        [cell setTaskLabelText:celltext];
        
        return cell;
        
    }

}

-(void)updateTableViewAnimated:(BOOL)animated{
    
    if (animated) {
        
        [_taskListTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        
    }else{
        
        [_taskListTableView reloadData];
        
    }
    
}

-(void)insertRowAtIndexPath:(NSIndexPath*)indexPath{
    
    [_taskListTableView beginUpdates];
    
    [_taskListTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [_taskListTableView endUpdates];
    
}

-(void)deleteRowAtIndexPath:(NSIndexPath*)indexPath{

    [_taskListTableView beginUpdates];
    
    [_taskListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [_taskListTableView endUpdates];

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger selectedCount = 0;
    
    if ([[_taskListTableView cellForRowAtIndexPath:indexPath] isKindOfClass:[DFMTableViewCell class]]) {
        
        DFMTableViewCell* cell = [_taskListTableView cellForRowAtIndexPath:indexPath];
        
        selectedCount = cell.selectedCount;
        
    }
    
    UIAlertView* info = [[UIAlertView alloc]initWithTitle:@"Information:" message:[NSString stringWithFormat:@"This option has been selected %i times",(int)selectedCount] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    
    [info show];
    
    [_taskListTableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - private methods
- (IBAction)addNewTaskBtn:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kDFM_ADD_NEW_TASK_NOTIFICATION_KEY object:nil];
    
}

/**
 
 *@brief: Add footer to remove extra separators
 
 **/
-(void)addFooter{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    
    v.backgroundColor = [UIColor clearColor];
    
    [_taskListTableView setTableFooterView:v];
    
    [_taskListTableView setSeparatorInset:UIEdgeInsetsZero];
    
    [_taskListTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];

}

#pragma mark - New Task

-(void)confirmTaskBtnPressed:(id)sender{
    
    if ([sender isKindOfClass:[UIView class]]) {

        NSString* taskContent = [[ViewComposer sharedComposer] getCurrentEditingTextFieldText];
        
        // check received text
        if ([taskContent isEqualToString:@""] || taskContent == nil) {

            UIAlertView* warning = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please fill all the fields! Or you can just tap the background to dismiss the view" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            
            [warning show];
            
        }else{
            // dismiss popup
            [(UIView*)sender dismissPresentingPopup];

            // load the text and add to tableView
            [model addActivity:taskContent];
            
            // insert the row
            [self insertRowAtIndexPath:[NSIndexPath indexPathForRow:[model getListOfActivities].count - 1 inSection:0]];
            
        }
    }
}

-(void)presentAddNewTaskPopup{
    
    KLCPopup* popup = [KLCPopup popupWithContentView:
                      [[ViewComposer sharedComposer]composeDecideForMeCreatingNewTaskPopupWithActionTarget:self andSelector:@selector(confirmTaskBtnPressed:)]
                        showType:KLCPopupShowTypeFadeIn
                        dismissType:KLCPopupDismissTypeFadeOut
                        maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    
    [popup show];
    
}

#pragma mark - Result View

-(void)dismissResultBtnPressed:(id)sender{
    
    if ([sender isKindOfClass:[UIView class]]) {
        
        [(UIView*)sender dismissPresentingPopup];
        
    }
    
    // flash the tableviewcell that was selected
    NSIndexPath* selected = [self indexPathForRowWithTaskName:tmpOutcome];
    
    if (selected != nil) {
        
        [self flashTableViewCellAtIndexPath:selected];
        
    }else{
        
        [Helper nslog:@"Wrong"];
        
    }
    
}

-(void)flashTableViewCellAtIndexPath:(NSIndexPath*)indexPath{
    
    DFMTableViewCell* cell = [_taskListTableView cellForRowAtIndexPath:indexPath];
    
    // increment cell selected count
    cell.selectedCount ++;
    
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    
    anim.fromValue = (id)cell.backgroundColor.CGColor;
    
    anim.toValue = (id)[Helper colorFromHex:@"#FD8080"].CGColor;
    
    anim.duration = 0.65f;
    
    anim.autoreverses = YES;
    
    [cell.layer addAnimation:anim forKey:@"backgroundColor"];
    
}

-(NSIndexPath*)indexPathForRowWithTaskName:(NSString*)name{
    
    for (NSInteger j = 0; j < [_taskListTableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [_taskListTableView numberOfRowsInSection:j]; ++i)
        {
            
            if ([[_taskListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]] isKindOfClass:[DFMTableViewCell class]]) {
                
                DFMTableViewCell* cell = (DFMTableViewCell*)[_taskListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                
                if (cell.taskLabel.text == name) {
                    
                    return [NSIndexPath indexPathForRow:i inSection:j];
                    
                }
                
            }
            
        }
    }
    
    return nil;
    
}

#pragma mark - Other action receivers

-(void)decideBtnPressed:(id)sender{
    
    NSString* result = [model decide];
    
    tmpOutcome = result;
    
    if (![result isEqualToString:@""]) {
        
        KLCPopup* popup = [KLCPopup popupWithContentView:
                           [[ViewComposer sharedComposer] composeDecideForMeShowDecisionPopupWithResult:result target:self andSelector:@selector(dismissResultBtnPressed:)]
                                                showType:KLCPopupShowTypeBounceInFromTop dismissType:KLCPopupDismissTypeBounceOutToBottom
                                                    maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:NO dismissOnContentTouch:NO];
        
        [popup show];
        
    }else{
        
        UIAlertView* warning = [[UIAlertView alloc]initWithTitle:@"Whatcha you doing?" message:@"Make up your mind first!" delegate:self cancelButtonTitle:@"Alright" otherButtonTitles:nil, nil];
        
        [warning show];
        
    }
    
    
}

-(void)resetBtnPressed:(id)sender{
    
    // reset the model
    [model reset];
    
    // update table
    [self updateTableViewAnimated:YES];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDFM_ADD_NEW_TASK_NOTIFICATION_KEY object:nil];
    
}


@end
