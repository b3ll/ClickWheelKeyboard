//
//  CWIntroViewController.m
//  ClickWheelKeyboard
//
//  Created by Adam Bell on 2014-08-23.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import "CWIntroViewController.h"

#import "UIBezierPath+iOS7RoundedRect.h"

#define TABLEVIEW_INSET 10.0

#define TABLEVIEW_CONTENT_OFFSET 44.0

#define KEYBOARD_PREVIEW_OFFSET 34.0

static NSString *const kCWIntroViewCellReuseIdentifier = @"CWIntroViewCellReuseIdentifier";

static const NSUInteger kCWInstructionsLabelTag = 0x13379001;

@interface CWIntroViewController ()

@end

@implementation CWIntroViewController {
  UIImageView *_keyboardPreviewView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.contentInset = UIEdgeInsetsMake(TABLEVIEW_CONTENT_OFFSET, 0.0, 0.0, 0.0);

  self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];

  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCWIntroViewCellReuseIdentifier];

  _keyboardPreviewView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[UIScreen mainScreen].bounds.size.width > 320.0 ? @"KeyboardPreview-Wide.png" : @"KeyboardPreview.png"]];
  _keyboardPreviewView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_keyboardPreviewView];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];

  CGRect bounds = self.view.bounds;

  UIView *footerView = [self.tableView viewWithTag:kCWInstructionsLabelTag];
  CGFloat keyboardFrameY = MAX(CGRectGetMaxY(footerView.frame) + KEYBOARD_PREVIEW_OFFSET, bounds.size.height - self.tableView.contentInset.top - _keyboardPreviewView.bounds.size.height);
  _keyboardPreviewView.frame = CGRectOffset(_keyboardPreviewView.bounds, 0.0, floor(keyboardFrameY));

  if (CGRectGetMaxY(_keyboardPreviewView.frame) > bounds.size.height - self.tableView.contentInset.top) {
    self.tableView.scrollEnabled = YES;

    // yolo
    if (self.tableView.contentSize.height < CGRectGetMaxY(_keyboardPreviewView.frame)) {
      self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, CGRectGetMaxY(_keyboardPreviewView.frame));
    }
  } else {
    self.tableView.scrollEnabled = NO;
  }
}

- (NSString *)title
{
  return @"Click Wheel Keyboard";
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCWIntroViewCellReuseIdentifier];

  UIImage *settingsIconImage = [UIImage imageNamed:@"SettingsIcon.png"];

  CAShapeLayer *iconMask = [CAShapeLayer layer];
  iconMask.frame = CGRectMake(0.0, 0.0, settingsIconImage.size.width, settingsIconImage.size.height);
  iconMask.path = [UIBezierPath bezierPathWithIOS7RoundedRect:iconMask.bounds cornerRadius:8.0].CGPath;

  cell.imageView.image = settingsIconImage;
  cell.imageView.layer.mask = iconMask;
  cell.imageView.clipsToBounds = YES;

  cell.textLabel.text = @"Settings";

  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return [NSLocalizedString(@"INTRO_TEXT", @"INTRO_TEXT") uppercaseString];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
  return NSLocalizedString(@"INSTRUCTIONS_TEXT", @"INSTRUCTIONS_TEXT");
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  CGFloat headerHeight = [tableView.delegate tableView:tableView heightForFooterInSection:section];

  UIView *wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, headerHeight)];
  wrapperView.backgroundColor = self.tableView.backgroundColor;

  NSString *headerText = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];

  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  headerLabel.numberOfLines = 1;
  headerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
  headerLabel.text = headerText;
  headerLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.36 alpha:1];
  headerLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
  [headerLabel sizeToFit];

  headerLabel.frame = CGRectMake(TABLEVIEW_INSET, wrapperView.bounds.size.height - headerLabel.bounds.size.height - TABLEVIEW_INSET, tableView.bounds.size.width, headerLabel.bounds.size.height);

  [wrapperView addSubview:headerLabel];

  return wrapperView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  NSString *headerText = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];

  NSDictionary *attributes = @{ NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] };

  return [headerText sizeWithAttributes:attributes].height + (TABLEVIEW_INSET * 2.0);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
  CGFloat footerHeight = [tableView.delegate tableView:tableView heightForFooterInSection:section];

  UIView *wrapperView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, footerHeight)];
  wrapperView.tag = kCWInstructionsLabelTag;

  NSString *footerText = [tableView.dataSource tableView:tableView titleForFooterInSection:section];

  UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(TABLEVIEW_INSET, TABLEVIEW_INSET, wrapperView.bounds.size.width - (TABLEVIEW_INSET * 2.0), wrapperView.bounds.size.height)];
  footerLabel.numberOfLines = 0;
  footerLabel.lineBreakMode = NSLineBreakByWordWrapping;
  footerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
  footerLabel.text = footerText;
  footerLabel.textColor = [UIColor colorWithRed:0.34 green:0.34 blue:0.36 alpha:1];
  footerLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;

  [wrapperView addSubview:footerLabel];

  return wrapperView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  NSString *footerText = [tableView.dataSource tableView:tableView titleForFooterInSection:section];

  NSDictionary *attributes = @{ NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2] };

  return [footerText sizeWithAttributes:attributes].height * 2.0;
}

@end
