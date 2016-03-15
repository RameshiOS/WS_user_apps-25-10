//
//  ColorToImage.m
//  RBashGenericRestaurantApp
//
//  Created by Ramesh on 4/23/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import "ColorToImage.h"

@implementation ColorToImage




+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end