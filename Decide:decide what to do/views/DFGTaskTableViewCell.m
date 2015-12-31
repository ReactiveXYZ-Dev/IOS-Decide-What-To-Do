//
//  DFGTaskTableViewCell.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 21/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DFGTaskTableViewCell.h"

#import "UIView+QuickSizeFetcher.h"

@implementation DFGTaskTableViewCell

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

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    // resize task label
    _taskName.frame = CGRectMake(0, 0, [self getFrameWidth], [self getFrameHeight]);
}

-(void)setUp{
    
    if (!_taskName) {
        
        _taskName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [self getBoundWidth], [self getFrameHeight])];
        
        _taskName.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_taskName];
        
    }

}

@end
