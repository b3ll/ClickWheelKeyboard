//
//  UIBezierPath+IOS7RoundedRect.m
//
//  Created by Matej Dunik on 11/12/13.
//  Copyright (c) 2013 PixelCut. All rights reserved except as below:
//  This code is provided as-is, without warranty of any kind. You may use it in your projects as you wish.
//

#import "UIBezierPath+IOS7RoundedRect.h"

@implementation UIBezierPath (IOS7RoundedRect)

#define TOP_LEFT(X, Y) CGPointMake(rect.origin.x + X * limitedRadius, rect.origin.y + Y * limitedRadius)
#define TOP_RIGHT(X, Y) CGPointMake(rect.origin.x + rect.size.width - X * limitedRadius, rect.origin.y + Y * limitedRadius)
#define BOTTOM_RIGHT(X, Y) CGPointMake(rect.origin.x + rect.size.width - X * limitedRadius, rect.origin.y + rect.size.height - Y * limitedRadius)
#define BOTTOM_LEFT(X, Y) CGPointMake(rect.origin.x + X * limitedRadius, rect.origin.y + rect.size.height - Y * limitedRadius)


+ (UIBezierPath*)bezierPathWithIOS7RoundedRect: (CGRect)rect cornerRadius: (CGFloat)radius;
{
    UIBezierPath* path = UIBezierPath.bezierPath;
    CGFloat limit = MIN(rect.size.width, rect.size.height) / 2 / 1.52866483;
    CGFloat limitedRadius = MIN(radius, limit);
    
    [path moveToPoint: TOP_LEFT(1.52866483, 0.00000000)];
    [path addLineToPoint: TOP_RIGHT(1.52866471, 0.00000000)];
    [path addCurveToPoint: TOP_RIGHT(0.66993427, 0.06549600) controlPoint1: TOP_RIGHT(1.08849323, 0.00000000) controlPoint2: TOP_RIGHT(0.86840689, 0.00000000)];
    [path addLineToPoint: TOP_RIGHT(0.63149399, 0.07491100)];
    [path addCurveToPoint: TOP_RIGHT(0.07491176, 0.63149399) controlPoint1: TOP_RIGHT(0.37282392, 0.16905899) controlPoint2: TOP_RIGHT(0.16906013, 0.37282401)];
    [path addCurveToPoint: TOP_RIGHT(0.00000000, 1.52866483) controlPoint1: TOP_RIGHT(0.00000000, 0.86840701) controlPoint2: TOP_RIGHT(0.00000000, 1.08849299)];
    [path addLineToPoint: BOTTOM_RIGHT(0.00000000, 1.52866471)];
    [path addCurveToPoint: BOTTOM_RIGHT(0.06549569, 0.66993493) controlPoint1: BOTTOM_RIGHT(0.00000000, 1.08849323) controlPoint2: BOTTOM_RIGHT(0.00000000, 0.86840689)];
    [path addLineToPoint: BOTTOM_RIGHT(0.07491111, 0.63149399)];
    [path addCurveToPoint: BOTTOM_RIGHT(0.63149399, 0.07491111) controlPoint1: BOTTOM_RIGHT(0.16905883, 0.37282392) controlPoint2: BOTTOM_RIGHT(0.37282392, 0.16905883)];
    [path addCurveToPoint: BOTTOM_RIGHT(1.52866471, 0.00000000) controlPoint1: BOTTOM_RIGHT(0.86840689, 0.00000000) controlPoint2: BOTTOM_RIGHT(1.08849323, 0.00000000)];
    [path addLineToPoint: BOTTOM_LEFT(1.52866483, 0.00000000)];
    [path addCurveToPoint: BOTTOM_LEFT(0.66993397, 0.06549569) controlPoint1: BOTTOM_LEFT(1.08849299, 0.00000000) controlPoint2: BOTTOM_LEFT(0.86840701, 0.00000000)];
    [path addLineToPoint: BOTTOM_LEFT(0.63149399, 0.07491111)];
    [path addCurveToPoint: BOTTOM_LEFT(0.07491100, 0.63149399) controlPoint1: BOTTOM_LEFT(0.37282401, 0.16905883) controlPoint2: BOTTOM_LEFT(0.16906001, 0.37282392)];
    [path addCurveToPoint: BOTTOM_LEFT(0.00000000, 1.52866471) controlPoint1: BOTTOM_LEFT(0.00000000, 0.86840689) controlPoint2: BOTTOM_LEFT(0.00000000, 1.08849323)];
    [path addLineToPoint: TOP_LEFT(0.00000000, 1.52866483)];
    [path addCurveToPoint: TOP_LEFT(0.06549600, 0.66993397) controlPoint1: TOP_LEFT(0.00000000, 1.08849299) controlPoint2: TOP_LEFT(0.00000000, 0.86840701)];
    [path addLineToPoint: TOP_LEFT(0.07491100, 0.63149399)];
    [path addCurveToPoint: TOP_LEFT(0.63149399, 0.07491100) controlPoint1: TOP_LEFT(0.16906001, 0.37282401) controlPoint2: TOP_LEFT(0.37282401, 0.16906001)];
    [path addCurveToPoint: TOP_LEFT(1.52866483, 0.00000000) controlPoint1: TOP_LEFT(0.86840701, 0.00000000) controlPoint2: TOP_LEFT(1.08849299, 0.00000000)];
    [path closePath];
    return path;
}

@end





