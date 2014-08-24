//
//  CWClickWheelToolbar.h
//  ClickWheelKeyboard
//
//  Created by Adam Bell on 2014-08-23.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWClickWheelToolbar : UIView

@property (nonatomic, assign) NSUInteger characterIndex;

@property (nonatomic, readonly) NSString *currentCharacter;

@property (nonatomic, readonly) NSUInteger maxCharacters;

@property (nonatomic, assign) BOOL CAPSLOCKENABLED;

- (void)setCharacterIndex:(NSInteger)characterIndex animated:(BOOL)animated;

@end
