//
//  KeyboardViewController.m
//  ClickkWheel
//
//  Created by Adam Bell on 2014-08-23.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import "KeyboardViewController.h"

#import "CWClickWheelView.h"

#import "CWClickWheelToolbar.h"

#import <AVFoundation/AVFoundation.h>

@interface KeyboardViewController () <CWClickWheelViewDelegate>
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@end

@implementation KeyboardViewController {
  CWClickWheelView *_clickWheel;
  CWClickWheelToolbar *_characterToolbar;
  
  UIButton *_deleteButton;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _clickWheel = [[CWClickWheelView alloc] initWithFrame:CGRectZero];
  _clickWheel.backgroundColor = [UIColor clearColor];
  _clickWheel.delegate = self;
  [self.view addSubview:_clickWheel];
  
  _characterToolbar = [[CWClickWheelToolbar alloc] initWithFrame:CGRectZero];
  [self.view addSubview:_characterToolbar];
  
  _nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_nextKeyboardButton setBackgroundImage:[UIImage imageNamed:@"GlobeIcon.png"] forState:UIControlStateNormal];
  [_nextKeyboardButton setBackgroundImage:[UIImage imageNamed:@"GlobeIconSelected.png"] forState:UIControlStateHighlighted];
  [_nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_nextKeyboardButton];

  _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_deleteButton setBackgroundImage:[UIImage imageNamed:@"DeleteIcon.png"] forState:UIControlStateNormal];
  [_deleteButton setBackgroundImage:[UIImage imageNamed:@"DeleteIconSelected.png"] forState:UIControlStateHighlighted];
  [_deleteButton addTarget:self action:@selector(_delete) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_deleteButton];
  
  self.view.backgroundColor = [UIColor colorWithRed:0.82 green:0.84 blue:0.86 alpha:1.0];
  self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  CGRect bounds = self.view.bounds;
  
  _clickWheel.frame = CGRectMake(0.0, 44.0, bounds.size.width, bounds.size.height - 44.0);
  [_clickWheel setNeedsDisplay];
  
  _characterToolbar.frame = CGRectMake(0.0, 0.0, bounds.size.width, 44.0);
  
  _nextKeyboardButton.frame = CGRectMake(10.0, self.view.bounds.size.height - 34.0, 24.0, 24.0);
  _deleteButton.frame = CGRectMake(bounds.size.width - 43.0, self.view.bounds.size.height - 34.0, 33.0, 24.0);
}

- (void)textWillChange:(id<UITextInput>)textInput {
  // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
  // The app has just changed the document's contents, the document context has been updated.
  
  UIColor *textColor = nil;
  if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
    textColor = [UIColor whiteColor];
  } else {
    textColor = [UIColor blackColor];
  }
  //[self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)_delete
{
  [self.textDocumentProxy deleteBackward];
}

#pragma mark - CWClickWheelDelegate
- (void)clickWheelDidAdvance:(CWClickWheelView *)clickWheel
{
  [_characterToolbar setCharacterIndex:_characterToolbar.characterIndex + 1 animated:YES];
}

- (void)clickWheelDidRetract:(CWClickWheelView *)clickWheel
{
  [_characterToolbar setCharacterIndex:_characterToolbar.characterIndex - 1 animated:YES];
}

- (void)clickWheel:(CWClickWheelView *)clickWheel didSelectButtonWithType:(CWClickWheelButtonType)buttonType
{
  switch (buttonType) {
    case CWClickWheelButtonTypeSelect:{
      [self.textDocumentProxy insertText:_characterToolbar.currentCharacter];
      break;
    }
    case CWClickWheelButtonTypeMenu:{
      [self _delete];
      break;
    }
    case CWClickWheelButtonTypePlayPause:{
      _characterToolbar.CAPSLOCKENABLED = !_characterToolbar.CAPSLOCKENABLED;
      break;
    }
    case CWClickWheelButtonTypePrevious:{
      [self.textDocumentProxy adjustTextPositionByCharacterOffset:-1];
      break;
    }
    case CWClickWheelButtonTypeNext:{
      if ([self.textDocumentProxy documentContextAfterInput].length != 0) {
        [self.textDocumentProxy adjustTextPositionByCharacterOffset:1];
      } else {
        [self.textDocumentProxy insertText:@" "];
      }
      break;
    }
      
    default:
      break;
  }
}

@end
