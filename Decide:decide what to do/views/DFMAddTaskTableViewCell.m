//
//  DFMAddTaskTableViewCell.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 8/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DFMAddTaskTableViewCell.h"

#import "DCUserDefaultKeyConstants.h"

@interface DFMAddTaskTableViewCell()



@end

@implementation DFMAddTaskTableViewCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        //self.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addNewTaskBtnPressed:(id)sender {
    
    // post notfication to parent view controller to trigger action
    [[NSNotificationCenter defaultCenter]postNotificationName:kDFM_ADD_NEW_TASK_NOTIFICATION_KEY object:nil];
    
}

-(NSString*)description{
    
    return @"add new task cell";
    
}
@end
