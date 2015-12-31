//
//  DCFGGetPrivilegeView.h
//  Decide:decide what to do
//
//  Created by Jackie Chung on 27/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCForGroupObject;

@protocol DCFGGetPrivilegeViewDelegate

@optional
-(void)viewDidFinishRetrievingPrivilegeData:(NSDictionary*)data;

@end

@interface DCFGGetPrivilegeView : UIView

@property (assign,nonatomic) id delegate;

@property (strong,nonatomic) NSString*roleName;

@property (assign,nonatomic) NSIndexPath* selectedIndexPath;

/**
 
 * @brief   Designated initializer to load up the model object
 
 * @param   DCForGroupObject model
 
 * @return  self
 
 */
-(instancetype)initWithModel:(DCForGroupObject*)src;

@end
