//
//  ViewController.m
//  ClickWheelKeyboard
//
//  Created by Adam Bell on 2014-08-23.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
  UITextView *_textView;
}
            
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  _textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
  _textView.font = [UIFont systemFontOfSize:28.0];
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = [UIScreen mainScreen].bounds;
  [button addTarget:_textView action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button];
  
  [self.view addSubview:_textView];
  
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  CGRect bounds = self.view.bounds;
  
  _textView.frame = CGRectMake(0.0, 22.0, bounds.size.width, 352.0);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
