//
//  CWClickWheelView.m
//  ClickWheelKeyboard
//
//  Created by Adam Bell on 2014-08-23.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import "CWClickWheelView.h"

static CGFloat kAngleDeltaRequiredToClick = 26.0;

static CGFloat kWheelInset = 10.0;
static CGFloat kWheelToButtonRatio = 0.64;

#define DEGREES_TO_RADIANS(angle) (angle * (M_PI / 180.0))
#define RADIANS_TO_DEGREES(angle) (angle * (180.0 / M_PI))

@interface CWClickWheelView () <UIInputViewAudioFeedback>
@end

@implementation CWClickWheelView {  
  CGFloat _previousAngle;
  CGFloat _totalAngle;
  
  CGRect _wheelRect;
  CGRect _selectButtonRect;
  CGRect _upButtonRect;
  CGRect _downButtonRect;
  CGRect _leftButtonRect;
  CGRect _rightButtonRect;
  
  BOOL _goingForwards;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame]) != nil) {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_buttonTapped:)];
    [self addGestureRecognizer:tapGesture];
  }
  
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  CGRect bounds = self.bounds;
  
  _wheelRect = CGRectInset(bounds, kWheelInset, kWheelInset);
  _wheelRect.size.width = _wheelRect.size.height;
  _wheelRect.origin.x = floor((bounds.size.width - _wheelRect.size.width) / 2.0);
  
  _selectButtonRect = CGRectInset(_wheelRect, (_wheelRect.size.width * kWheelToButtonRatio) / 2.0, (_wheelRect.size.width * kWheelToButtonRatio) / 2.0);
  
  CGFloat wheelWidth = (_wheelRect.size.height - _selectButtonRect.size.height) / 2.0;
  
  _upButtonRect = _selectButtonRect;
  _upButtonRect.origin.y = 0.0;
  _upButtonRect.size.height = wheelWidth;
  
  _downButtonRect = _selectButtonRect;
  _downButtonRect.origin.y = _wheelRect.size.height - wheelWidth;
  _downButtonRect.size.height = wheelWidth;
  
  _leftButtonRect = _selectButtonRect;
  _leftButtonRect.origin.x = _wheelRect.origin.x;
  _leftButtonRect.size.width = wheelWidth;
  
  _rightButtonRect = _selectButtonRect;
  _rightButtonRect.origin.x = (_wheelRect.origin.x + _wheelRect.size.width) - wheelWidth;
  _rightButtonRect.size.width = wheelWidth;
  
  [self setNeedsDisplay];
}

#pragma mark - Interaction
- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer
{
  CGPoint currentPoint = [panGestureRecognizer locationInView:self];
  
  CGPoint centerPoint = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
  CGFloat deltaX = currentPoint.x - centerPoint.x;
  CGFloat deltaY = currentPoint.y - centerPoint.y;
  
  CGFloat currentAngle = RADIANS_TO_DEGREES(atan2(deltaY, deltaX)) + 90.0;
  if (currentAngle < 0.0) {
    currentAngle = 180.0 + (180 + currentAngle);
  }

  switch (panGestureRecognizer.state) {
    case UIGestureRecognizerStateBegan: {
      _previousAngle = currentAngle;
      
      _totalAngle = 0.0;
      break;
    }
    case UIGestureRecognizerStateChanged: {
      if (CGRectContainsPoint(_selectButtonRect, currentPoint)) {
        _totalAngle = 0.0;
        _previousAngle = CGFLOAT_MAX;
        break;
      }
      
      if (_previousAngle == CGFLOAT_MAX) {
        _previousAngle = currentAngle;
        break;
      }
      
      CGFloat radPrevious = _previousAngle * (M_PI / 180.0);
      CGFloat radCurrent = currentAngle * (M_PI / 180.0);
      
      _totalAngle += RADIANS_TO_DEGREES(atan2(sin(radPrevious - radCurrent), cos(radPrevious - radCurrent)));
      _previousAngle = currentAngle;
      
      BOOL shouldClick = NO;
      
      if ((!_goingForwards && _totalAngle < 0.0) || (_goingForwards && _totalAngle > 0.0)) {
        shouldClick = fabs(_totalAngle) > kAngleDeltaRequiredToClick * 2.0;
      } else {
        shouldClick = fabs(_totalAngle) > kAngleDeltaRequiredToClick;
      }
      
      if (shouldClick) {
        [panGestureRecognizer setTranslation:CGPointZero inView:self];
        
        if (_totalAngle < 0.0) {
          if ([self.delegate respondsToSelector:@selector(clickWheelDidAdvance:)]) {
            [self.delegate clickWheelDidAdvance:self];
            _goingForwards = YES;
          }
        } else {
          if ([self.delegate respondsToSelector:@selector(clickWheelDidRetract:)]) {
            [self.delegate clickWheelDidRetract:self];
            _goingForwards = NO;
          }
        }
        
        _totalAngle = 0.0;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
      }
      
      break;
    }
    case UIGestureRecognizerStateCancelled:
    case UIGestureRecognizerStateEnded:{
      
      break;
    }
      
    default:
      break;
  }
}

#pragma mark - Interaction
- (void)_buttonTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
  if (![self.delegate respondsToSelector:@selector(clickWheel:didSelectButtonWithType:)]) {
    return;
  }
  
  CGPoint tappedPoint = [tapGestureRecognizer locationInView:self];
  
  if (CGRectContainsPoint(_selectButtonRect, tappedPoint)) {
    [self.delegate clickWheel:self didSelectButtonWithType:CWClickWheelButtonTypeSelect];
  } else if (CGRectContainsPoint(_upButtonRect, tappedPoint)) {
    [self.delegate clickWheel:self didSelectButtonWithType:CWClickWheelButtonTypeMenu];
  } else if (CGRectContainsPoint(_downButtonRect, tappedPoint)) {
    [self.delegate clickWheel:self didSelectButtonWithType:CWClickWheelButtonTypePlayPause];
  } else if (CGRectContainsPoint(_leftButtonRect, tappedPoint)) {
    [self.delegate clickWheel:self didSelectButtonWithType:CWClickWheelButtonTypePrevious];
  } else if (CGRectContainsPoint(_rightButtonRect, tappedPoint)) {
    [self.delegate clickWheel:self didSelectButtonWithType:CWClickWheelButtonTypeNext];
  }
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();

  [[UIColor whiteColor] setFill];
  CGContextFillEllipseInRect(ctx, _wheelRect);
  
  [[UIColor colorWithRed:0.82 green:0.84 blue:0.86 alpha:1.0] setFill];
  CGContextFillEllipseInRect(ctx, _selectButtonRect);
}

@end
