//
//  UIView+QuickSizeFetcher.h
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 3/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface UIView(QuickSizeFetcher)

-(CGFloat)getFrameHeight;

-(CGFloat)getFrameWidth;

-(CGFloat)getFrameOriginX;

-(CGFloat)getFrameOriginY;

-(CGFloat)getBoundHeight;

-(CGFloat)getBoundWidth;

@end
