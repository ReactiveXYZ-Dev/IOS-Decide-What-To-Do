//
//  DCFGResultView.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 29/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DCFGResultView.h"

#import "RoleObject.h"

#import "UIView+QuickSizeFetcher.h"

#import "Helper.h"

#import "DCUserDefaultKeyConstants.h"

/** custom UITableViewCell **/
@interface DCFGTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel* taskBelongToRoleLabel;

@end

@implementation DCFGTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
        
    }
    
    return self;
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self updateConstraints];
    
}

-(void)setUp{
    // decorations
    self.backgroundColor = [Helper colorFromHex:@"#e3f2fd"];
    
    self.layer.cornerRadius = 5.0f;
    
    // add label
    _taskBelongToRoleLabel = [[UILabel alloc]init];
    
    _taskBelongToRoleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _taskBelongToRoleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_taskBelongToRoleLabel];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_taskBelongToRoleLabel,self.contentView);
    
    // add constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_taskBelongToRoleLabel]-(0)-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_taskBelongToRoleLabel]-(0)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
}

@end

/** the main view **/

@interface DCFGResultView()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) UITableView* resultTableView;

@end

@implementation DCFGResultView

#pragma mark - Initializers
-(instancetype)initWithData:(NSArray<RoleObject *> *)data{
    
    if (self = [super init]) {
        
        _data = data;
        
        [self setUp];
        
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame Data:(NSArray<RoleObject *> *)data{
    
    if (self = [super initWithFrame:frame]) {
        
        _data = data;
        
        [self setUp];
        
    }
    
    return self;
    
}

#pragma mark - Private methods

-(void)setUp{
    
    [self validateForNotification];
    
    _resultTableView = [[UITableView alloc]init];
    
    _resultTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _resultTableView.layer.cornerRadius = 5.0f;
    
    _resultTableView.layer.borderWidth = 0.5f;
    
    _resultTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _resultTableView.delegate = self;
    
    _resultTableView.dataSource = self;
    
    [self addSubview:_resultTableView];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(self,_resultTableView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_resultTableView]-(0)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(25)-[_resultTableView]-(25)-|" options:0 metrics:nil views:views]];
}

-(void)validateForNotification{
    
    if ([self isHelperDisabled]) {
        
        // show alert
        UIAlertView* notification = [[UIAlertView alloc]initWithTitle:@"Info" message:@"Tasks are distributed under each participant's name. They have been calculated thoroughly :) \n If you want to dismiss the result, just tap the backgroud." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Never see this again", nil];
        
        notification.tag = 0;
        
        [notification show];
        
    }
    
}

-(BOOL)isHelperDisabled{
    
    if ([Helper getObjectFromUserDefaultWithName:kIS_NOTIFICATION_DISABLED_USER_DEFAULT_KEY]) {
        
        return NO;
    
    }
    
    
    return YES;
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 0) {
        
        // notification alert
        if (buttonIndex == 1) {
            
            // never see this again
            [Helper setUserDefault:kIS_NOTIFICATION_DISABLED_USER_DEFAULT_KEY WithObject:[NSNumber numberWithBool:YES]];
            
        }
        
    }
    
}

#pragma mark - UITableView Delegates/Datasource

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* roleHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [tableView getFrameWidth], 50)];
    
    roleHeaderView.backgroundColor = [UIColor whiteColor];
    
    UILabel* roleTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [roleHeaderView getFrameWidth], [roleHeaderView getFrameHeight])];
    
    roleTitleLabel.text = [NSString stringWithFormat:@"%@ should do...",_data[section].name];
    
    roleTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    roleTitleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo" size:30];
    
    [roleHeaderView addSubview:roleTitleLabel];
    
    return roleHeaderView;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_data[section] retrieveAssignedTasks].count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"cell";
    
    DCFGTableViewCell* cell = (DCFGTableViewCell*)[_resultTableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[DCFGTableViewCell alloc]init];
        
    }
    
    // set up data
    cell.taskBelongToRoleLabel.text = [_data[indexPath.section] retrieveAssignedTasks][indexPath.row];
    
    return cell;
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kDFG_DECISION_RESULT_VIEW_DISMISSED object:nil];
}

@end


