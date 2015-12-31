//
//  TableViewCell.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 8/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DFMTableViewCell.h"

#import "UIView+QuickSizeFetcher.h"

@implementation DFMTableViewCell{
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
        
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

-(void)setUp{
    
    _selectedCount = 0;
    
    self.backgroundColor = [UIColor clearColor];
    
    if (!_taskLabel) {
        
        
        _taskLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [self getFrameWidth], [self getFrameHeight])];
        
        _taskLabel.textAlignment = NSTextAlignmentCenter;
        
        [_taskLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:28]];
        
        [_taskLabel setTextColor:[UIColor lightGrayColor]];
        
        _taskLabel.text = @"what?";
        
        [self addSubview:_taskLabel];
        
    }

    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    // resize task label
    _taskLabel.frame = CGRectMake(0, 0, [self getFrameWidth], [self getFrameHeight]);
}

-(void)setTaskLabelText:(NSString *)text{
    
    _taskLabel.text = text;
    
}
@end
