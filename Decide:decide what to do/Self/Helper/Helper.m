//
//  Helper.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 3/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "Helper.h"

@implementation Helper


+(NSString*)stringWithInteger:(NSInteger)integer{
    
    return [NSString stringWithFormat:@"%i",integer];
 
}

+(NSString*)stringDescribingCGRect:(CGRect)rect{
    
    return NSStringFromCGRect(rect);
    
}

+(void)nslog:(NSString *)string{
    
    NSLog(@"%@",string);
    
}

@end
