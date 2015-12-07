//
//  UIView+QuickSizeFetcher.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 3/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "UIView+QuickSizeFetcher.h"

@implementation UIView(QuickSizeFetcher)

-(CGFloat)getFrameHeight {
    
    return self.frame.size.height;
    
}

-(CGFloat)getFrameWidth {
    
    return self.frame.size.width;
    
}

-(CGFloat)getFrameOriginX{
    
    return self.frame.origin.x;
    
}

-(CGFloat)getFrameOriginY{
    
    return self.frame.origin.y;
    
}

-(CGFloat)getBoundHeight{
    
    return self.bounds.size.height;
    
}

-(CGFloat)getBoundWidth{
    
    return self.bounds.size.width;
    
}

@end
