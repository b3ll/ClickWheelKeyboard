//
//  UIBezierPath+IOS7RoundedRect.h
//
//  Created by Matej Dunik on 11/12/13.
//  Copyright (c) 2013 PixelCut. All rights reserved except as below:
//  This code is provided as-is, without warranty of any kind. You may use it in your projects as you wish.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (IOS7RoundedRect)

+ (UIBezierPath*)bezierPathWithIOS7RoundedRect: (CGRect)rect cornerRadius: (CGFloat)radius;

@end
