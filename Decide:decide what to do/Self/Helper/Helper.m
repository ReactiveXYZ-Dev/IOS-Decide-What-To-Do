//
//  Helper.m
//  Decide:decide what to do
//
//  Created by Jackie Zhang on 3/12/2015.
//  Copyright © 2015 Future Innovation Studio. All rights reserved.
//

#import "Helper.h"

#import "DCForMeObject.h"

@implementation Helper


+(NSString*)stringWithInteger:(NSInteger)integer{
    
    return [NSString stringWithFormat:@"%li",(long)integer];
 
}

+(NSString*)stringDescribingCGRect:(CGRect)rect{
    
    return NSStringFromCGRect(rect);
    
}


+(void)nslog:(NSObject *)object{
    
    NSLog(@"%@",object);
    
}

+(void)nslogFrame:(CGRect)frame{
    
    NSLog(@"origin x: %f, y: %f. Size width: %f, height: %f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    
}


+(UIImage*)resizeImageWithSourceName:(NSString *)imageName AndScale:(float)scale{
    
    return [UIImage imageWithCGImage:[UIImage imageNamed:imageName].CGImage scale:scale orientation:UIImageOrientationUp];
    
}

+(UIColor*)colorFromHex:(NSString *)hex{
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];

    
}

+(BOOL)is:(int)number inRangeBetween:(int)a and:(int)b{
    
    if (number >= a && number < b) {
        
        return true;
        
    }
    
    return false;
}

+(void)setUserDefault:(NSString *)name WithObject:(id)object{
    
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:name];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(id)getObjectFromUserDefaultWithName:(NSString *)name{
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:name];
    
}

+(void)removeObjectFromUserDefaultWithName:(NSString *)name{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:name];
    
}



@end
