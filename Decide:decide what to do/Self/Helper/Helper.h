//
//  Helper.h
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 3/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface Helper : NSObject

+(NSString*)stringWithInteger:(NSInteger)integer;

+(NSString*)stringDescribingCGRect:(CGRect)rect;

+(void)nslog:(NSString*)string;

+(UIImage*)resizeImageWithSourceName:(NSString*)imageName AndScale:(float)scale;

@end
