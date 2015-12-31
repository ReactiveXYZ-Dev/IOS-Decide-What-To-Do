//
//  DCFGResultView.h
//  Decide:decide what to do
//
//  Created by Jackie Chung on 29/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoleObject;

@interface DCFGResultView : UIView

@property (strong,nonatomic)NSArray<RoleObject*>* data;

/**
 
 * @brief   Designated initializer with import of data
 
 * @param   NSArray rolesData
 
 * @return  self
 
 */
-(instancetype)initWithData:(NSArray<RoleObject*>*)data;

/**
 
 * @brief   Designated initializer with import of data in a defined frame
 
 * @param   CGRect frame, NSArray rolesData
 
 * @return  self
 
 */
-(instancetype)initWithFrame:(CGRect)frame Data:(NSArray<RoleObject*>*)data;

@end
