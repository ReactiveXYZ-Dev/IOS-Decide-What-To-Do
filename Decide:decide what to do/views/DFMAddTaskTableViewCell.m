//
//  DFMAddTaskTableViewCell.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 8/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DFMAddTaskTableViewCell.h"

#import "DCUserDefaultKeyConstants.h"

#import "UIView+QuickSizeFetcher.h"

#import "Helper.h"

@interface DFMAddTaskTableViewCell()

@property (strong,nonatomic)UIButton* addTaskBtn;

@end

@implementation DFMAddTaskTableViewCell


- (void)awakeFromNib {
    
    // Initialization code
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

    
}

- (void)addNewTaskBtnPressed:(id)sender {
    
    // post notfication to parent view controller to trigger action
    [[NSNotificationCenter defaultCenter]postNotificationName:kDFM_ADD_NEW_TASK_NOTIFICATION_KEY object:nil];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
    if (!_addTaskBtn) {
        
        _addTaskBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _addTaskBtn.frame = CGRectMake(0, 0, [self getFrameWidth], [self getFrameHeight]);
        
        [_addTaskBtn setTitle:@"Add Tasks" forState:UIControlStateNormal];
        
        [_addTaskBtn.titleLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:18]];
        [_addTaskBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [_addTaskBtn addTarget:self action:@selector(addNewTaskBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_addTaskBtn];
        
    }
    
}

-(NSString*)description{
    
    return @"Add new task cell";
    
}
@end
