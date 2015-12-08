//
//  UIScrollView+UpdateContentSize.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 8/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "UIScrollView+UpdateContentSize.h"

@implementation UIScrollView(UpdateContentSize)

-(void)updateContentSize{
    
    CGRect contentRect = CGRectZero;
    
    for (UIView *view in self.subviews) {
        
        contentRect = CGRectUnion(contentRect, view.frame);
        
    }
    
    self.contentSize = contentRect.size;
    
}

@end

