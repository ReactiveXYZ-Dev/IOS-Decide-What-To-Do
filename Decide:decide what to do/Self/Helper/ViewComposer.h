//
//  ViewComposer.h
//  Decide:decide what to do
//
//  Created by Jackie Chung on 22/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EAIntroView.h"

typedef NS_ENUM(NSInteger){
    
    POPUP_ADD_NEW_ROLE = 0,
    
    POPUP_ADD_NEW_TASK = 1,
    
    POPUP_ADD_PRIVILEGE = 2
    
} POPUP_TYPE;

@import UIKit;

@class DCForGroupObject;

@class RoleObject;

@interface ViewComposer : NSObject <EAIntroDelegate>

/**
 
 *@brief    Singleton initializer
 
 **/
+(instancetype)sharedComposer;


// Popup Views

/**
 
 * @brief   Generate an UIView to show a quick decision result
 
 * @param   Bool result,id target,SEL action
 
 * @return  UIView
 
 */
-(UIView*)composeQuickDecisionPopupWithResult:(BOOL)result actionTarget:(id)target andSelector:(SEL)sel;

/**
 
 * @brief   Generate an UIView to show a popup to create a new task for "me"
 
 * @param   id target,SEL action
 
 * @return  UIView
 
 */
-(UIView*)composeDecideForMeCreatingNewTaskPopupWithActionTarget:(id)target andSelector:(SEL)sel;

/**
 
 * @brief   Generate an UIView to show the decided result for "me"
 
 * @param   id target,SEL action
 
 * @return  UIView
 
 */
-(UIView*)composeDecideForMeShowDecisionPopupWithResult:(NSString*)result target:(id)target andSelector:(SEL)sel;
/**
 
 * @brief   Generate an UIView to add new participant to the database
 
 * @param   id target, SEL action
 
 * @return  UIView
 
 */
-(UIView*)composeDecideForGroupAddNewRolePopupWithTarget:(id)target andSelector:(SEL)sel;

/**
 
 * @brief   Generate an UIView to add new role to the database
 
 * @param   id target, SEL action
 
 * @return  UIView
 
 */
-(UIView*)composeDecideForGroupAddNewTaskPopupWithTarget:(id)target andSelector:(SEL)sel;

/**
 
 * @brief   Generate an UIView to assign a role with privilege of performing one certain task that ranges from 0% - 50%
 
 * @param   NSString name, DCForGroupObject model, id target,SEL action
 
 * @return  UIView
 
 */
-(UIView*)composeDecideForGroupAddPrivilegePopupWithParticipantName:(NSString*)name model:(DCForGroupObject*)model target:(id)target andSelector:(SEL)sel;

/**
 
 * @brief   Generate an UIView to present the alert popup containing the decided result in DecideForGroupViewController
 
 * @param   NSDictionary dataSet, id target, SEL action
 
 * @return  UIView
 
 */
-(UIView*)composeDecideForGroupShowDecisionResultPopupWithResultDataSet:(NSArray<RoleObject*>*)data;

// Partials

/**
 
 * @brief   Generate a separator line horizontally or vertically aligned
 
 * @param   CGRect frame, UIColor color, Align type
 
 * @return  UIView
 
 */
-(UIView*)composeSeparatorViewWithFrame:(CGRect)frame Color:(UIColor*)color;

/**
 
 * @brief   Generate a separator line with gradient transition
 
 * @param   CGRect frame, UIColor bgColor, NSArray Transitions, NSDictionary configs
 
 * @return  UIView
 
 */
-(UIView*)composeSeparatorViewWithFrame:(CGRect)frame BgColor:(UIColor*)color ColorTransition:(NSArray*)transitions Config:(NSDictionary*)configs;

/**
 
 * @brief   Generate an EAIntroView instance for the app's tutorial page
 
 * @return  EAIntroView
 
 */
-(EAIntroView*)appTutorialViews;

// Data from views

/**
 
 * @brief   Get the text input of current editing textfield
 
 * @param   nil
 
 * @return  NSString
 
 */
-(NSString*)getCurrentEditingTextFieldText;

@end
