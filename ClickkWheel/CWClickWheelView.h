//
//  CWClickWheelView.h
//  ClickWheelKeyboard
//
//  Created by Adam Bell on 2014-08-23.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CWClickWheelButtonType) {
  CWClickWheelButtonTypeSelect,
  CWClickWheelButtonTypeMenu,
  CWClickWheelButtonTypePrevious,
  CWClickWheelButtonTypeNext,
  CWClickWheelButtonTypePlayPause
};

@protocol CWClickWheelViewDelegate;

@interface CWClickWheelView : UIControl

@property (nonatomic, copy) void (^playClickSound)(void);
@property (nonatomic, weak) id<CWClickWheelViewDelegate> delegate;

@end

@protocol CWClickWheelViewDelegate <NSObject>

- (void)clickWheel:(CWClickWheelView *)clickWheel didSelectButtonWithType:(CWClickWheelButtonType)buttonType;
- (void)clickWheelDidAdvance:(CWClickWheelView *)clickWheel;
- (void)clickWheelDidRetract:(CWClickWheelView *)clickWheel;

@end