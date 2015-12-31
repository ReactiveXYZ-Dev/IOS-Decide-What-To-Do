//
//  DFGRoleTableViewCell.m
//  Decide:decide what to do
//
//  Created by Jackie Chung on 21/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "DFGRoleTableViewCell.h"

#import "Helper.h"

#import "DCUserDefaultKeyConstants.h"

@implementation DFGRoleTableViewCell

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
    
    [self updateConstraints];
    
}

-(void)setUp{
    
    // Set up role name label
    _roleName = [[UILabel alloc]init];
    
    _roleName.textAlignment = NSTextAlignmentCenter;
    
    _roleName.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_roleName];
    
    // Set up add privilege button
    _addPrivilegeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_addPrivilegeBtn setImage:[UIImage imageNamed:@"vip.png"] forState:UIControlStateNormal];
    
    [_addPrivilegeBtn addTarget:self action:@selector(postPresentAddPrivilegePopupNotification:) forControlEvents:UIControlEventTouchUpInside];
    
    _addPrivilegeBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_addPrivilegeBtn];
    
    NSDictionary* views = NSDictionaryOfVariableBindings(self.contentView,_roleName,_addPrivilegeBtn);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[_roleName]-(10)-[_addPrivilegeBtn]-(20)-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[_roleName]-(5)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[_addPrivilegeBtn]-(10)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
}

-(void)postPresentAddPrivilegePopupNotification:(id) sender{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kDFG_PRESENT_ADD_PRIVILEGE_POPUP_NOTIFICATION_KEY object:nil userInfo:@{
                                @"role_name":_roleName.text
                            }];
    
}

@end
