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

#import "DFMAddTaskTableViewCell.h"

#import "Helper.h"

@interface DecideForMeViewController()<UITableViewDelegate,UITableViewDataSource>{
    
    DCForMeObject* model;
    
}

@property (weak, nonatomic) IBOutlet UITableView *taskListTableView;

@property (weak, nonatomic) IBOutlet UIButton *decideBtn;

@end

@implementation DecideForMeViewController


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    // init decide for me object
    model = [[DCForMeObject alloc]initWithActivityList:@[]];
    
    // init
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
    
    return 63;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"cell";
    //NSLog(@"%li",(long)indexPath.row);
    // if the row is at end -> queue add task cell
    if (indexPath.row == ([model getListOfActivities].count)) {
        
        DFMAddTaskTableViewCell* cell = (DFMAddTaskTableViewCell*)[_taskListTableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"DFMAddTaskTableViewCell" owner:self options:nil];
            
            cell = [nib objectAtIndex:0];
            
        }
        
        NSLog(@"%@",cell);
        
        return cell;
        
    }else{
        
        // normal rows
        DFMTableViewCell* cell = (DFMTableViewCell*)[_taskListTableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            
            NSArray* nib = [[NSBundle mainBundle]loadNibNamed:@"DFMTableViewCell" owner:self options:nil];
            
            cell = [nib objectAtIndex:0];
            
        }
        
        // config normal list cells
        cell.taskLabel.text = [[model getListOfActivities] objectAtIndex:indexPath.row];
        
        return cell;
        
    }
    
    
    
}

@end
