//
//  CWClickWheelToolbar.m
//  ClickWheelKeyboard
//
//  Created by Adam Bell on 2014-08-23.
//  Copyright (c) 2014 Adam Bell. All rights reserved.
//

#import "CWClickWheelToolbar.h"

#import <AudioToolbox/AudioToolbox.h>

#import <POP/POP.h>

static NSString *const kCharacterCollectionViewCellReuseIdentifier = @"kCharacterCollectionViewCellKey";
static NSString *const kCharacterCollectionViewScrollViewAnimationKey = @"kCollectionViewScrollViewAnimationKey";

// lulz.
static NSString *const characterLookup = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,!?@#/\"'-+=$%^&*;:()[]{}<>";
static NSString *const emojiLookup = @"😄😃😀😊☺😉😍😘😚😗😙😜😝😛😳😁😔😌😒😞😣😢😂😭😪😥😰😅😓😩😫😨😱😠😡😤😖😆😋😷😎😴😵😲😟😦😧😈👿😮😬😐😕😯😶😇😏😑👲👳👮👷💂👶👦👧👨👩👴👵👱👼👸😺😸😻😽😼🙀😿😹😾👹👺🙈🙉🙊💀👽💩🔥✨🌟💫💥💢💦💧💤💨👂👀👃👅👄👍👎👌👊✊✌👋✋👐👆👇👉👈🙌🙏☝👏💪🚶🏃💃👫👪👬👭💏💑👯🙆🙅💁🙋💆💇💅👰🙎🙍🙇🎩👑👒👟👞👡👠👢👕👔👚👗🎽👖👘👙💼👜👝👛👓🎀🌂💄💛💙💜💚❤💔💗💓💕💖💞💘💌💋💍💎👤👥💬👣💭🐶🐺🐱🐭🐹🐰🐸🐯🐨🐻🐷🐽🐮🐗🐵🐒🐴🐑🐘🐼🐧🐦🐤🐥🐣🐔🐍🐢🐛🐝🐜🐞🐌🐙🐚🐠🐟🐬🐳🐋🐄🐏🐀🐃🐅🐇🐉🐎🐐🐓🐕🐖🐁🐂🐲🐡🐊🐫🐪🐆🐈🐩🐾💐🌸🌷🍀🌹🌻🌺🍁🍃🍂🌿🌾🍄🌵🌴🌲🌳🌰🌱🌼🌐🌞🌝🌚🌑🌒🌓🌔🌕🌖🌗🌘🌜🌛🌙🌍🌎🌏🌋🌌🌠⭐☀⛅☁⚡☔❄⛄🌀🌁🌈🌊🎍💝🎎🎒🎓🎏🎆🎇🎐🎑🎃👻🎅🎄🎁🎋🎉🎊🎈🎌🔮🎥📷📹📼💿📀💽💾💻📱☎📞📟📠📡📺📻🔊🔉🔈🔇🔔🔕📢📣⏳⌛⏰⌚🔓🔒🔏🔐🔑🔎💡🔦🔆🔅🔌🔋🔍🛁🛀🚿🚽🔧🔩🔨🚪🚬💣🔫🔪💊💉💰💴💵💷💶💳💸📲📧📥📤✉📩📨📯📫📪📬📭📮📦📝📄📃📑📊📈📉📜📋📅📆📇📁📂✂📌📎✒✏📏📐📕📗📘📙📓📔📒📚📖🔖📛🔬🔭📰🎨🎬🎤🎧🎼🎵🎶🎹🎻🎺🎷🎸👾🎮🃏🎴🀄🎲🎯🏈🏀⚽⚾🎾🎱🏉🎳⛳🚵🚴🏁🏇🏆🎿🏂🏊🏄🎣☕🍵🍶🍼🍺🍻🍸🍹🍷🍴🍕🍔🍟🍗🍖🍝🍛🍤🍱🍣🍥🍙🍘🍚🍜🍲🍢🍡🍳🍞🍩🍮🍦🍨🍧🎂🍰🍪🍫🍬🍭🍯🍎🍏🍊🍋🍒🍇🍉🍓🍑🍈🍌🍐🍍🍠🍆🍅🌽🏠🏡🏫🏢🏣🏥🏦🏪🏩🏨💒⛪🏬🏤🌇🌆🏯🏰⛺🏭🗼🗾🗻🌄🌅🌃🗽🌉🎠🎡⛲🎢🚢⛵🚤🚣⚓🚀✈💺🚁🚂🚊🚉🚞🚆🚄🚅🚈🚇🚝🚋🚃🚎🚌🚍🚙🚘🚗🚕🚖🚛🚚🚨🚓🚔🚒🚑🚐🚲🚡🚟🚠🚜💈🚏🎫🚦🚥⚠🚧🔰⛽🏮🎰♨🗿🎪🎭📍🚩🇯🇵🇰🇷🇩🇪🇨🇳🇺🇸🇫🇷🇪🇸🇮🇹🇷🇺🇬🇧1⃣2⃣3⃣4⃣5⃣6⃣7⃣8⃣9⃣0⃣🔟🔢#⃣🔣⬆⬇⬅➡🔠🔡🔤↗↖↘↙↔↕🔄◀▶🔼🔽↩↪ℹ⏪⏩⏫⏬⤵⤴🆗🔀🔁🔂🆕🆙🆒🆓🆖📶🎦🈁🈯🈳🈵🈴🈲🉐🈹🈺🈶🈚🚻🚹🚺🚼🚾🚰🚮🅿♿🚭🈷🈸🈂Ⓜ🛂🛄🛅🛃🉑㊙㊗🆑🆘🆔🚫🔞📵🚯🚱🚳🚷🚸⛔✳❇❎✅✴💟🆚📳📴🅰🅱🆎🅾💠➿♻♈♉♊♋♌♍♎♏♐♑♒♓⛎🔯🏧💹💲💱©®™❌‼⁉❗❓❕❔⭕🔝🔚🔙🔛🔜🔃🕛🕧🕐🕜🕑🕝🕒🕞🕓🕟🕔🕠🕕🕖🕗🕘🕙🕚🕡🕢🕣🕤🕥🕦✖➕➖➗♠♥♣♦💮💯✔☑🔘🔗➰〰〽🔱◼◻◾◽▪▫🔺🔲🔳⚫⚪🔴🔵🔻⬜⬛🔶🔷🔸🔹";

@interface CWClickWheelToolbar () <UICollectionViewDelegate, UICollectionViewDataSource>
@end

@implementation CWClickWheelToolbar {
  UICollectionViewFlowLayout *_characterCollectionViewLayout;
  UICollectionView *_characterCollectionView;
  
  POPSpringAnimation *_scrollViewSpringAnimation;
  
  SystemSoundID _clickSoundID;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame]) != nil) {
    _characterCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    _characterCollectionViewLayout.itemSize = CGSizeMake(44.0, 44.0);
    _characterCollectionViewLayout.minimumInteritemSpacing = 0.0;
    _characterCollectionViewLayout.minimumLineSpacing = 0.0;
    _characterCollectionViewLayout.sectionInset = UIEdgeInsetsZero;
    _characterCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _characterCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:_characterCollectionViewLayout];
    [_characterCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCharacterCollectionViewCellReuseIdentifier];
    _characterCollectionView.delegate = self;
    _characterCollectionView.dataSource = self;
    _characterCollectionView.backgroundColor = [UIColor colorWithRed:0.67 green:0.7 blue:0.74 alpha:1.0];
    [self addSubview:_characterCollectionView];
    
    [_characterCollectionView reloadData];
    [self _fixEverythingBecauseImLazy];
    
    NSString *clickSoundFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Click" ofType:@"caf"];
    NSURL *clickSoundFileURL = [NSURL URLWithString:clickSoundFilePath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)clickSoundFileURL, &_clickSoundID);
    
    self.userInteractionEnabled = NO;
  }
  
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  CGRect bounds = self.bounds;
  
  _characterCollectionView.frame = bounds;
  _characterCollectionViewLayout.itemSize = CGSizeMake(bounds.size.height, bounds.size.height);
  _characterCollectionViewLayout.sectionInset = UIEdgeInsetsMake(0.0, floor((bounds.size.width - 44.0) / 2.0), 0.0, floor((bounds.size.width - 44.0) / 2.0));
}

- (void)setCharacterIndex:(NSInteger)characterIndex animated:(BOOL)animated
{
  if (characterIndex < 0) {
    characterIndex = 0;
  }
  
  if (characterIndex > self.maxCharacters - 1) {
    characterIndex = self.maxCharacters - 1;
  }
  
  if (_characterIndex == characterIndex) {
    return;
  }
  
  NSInteger previousIndex = _characterIndex;
  _characterIndex = characterIndex;

  [_characterCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:previousIndex inSection:0] animated:NO];

  [_characterCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:characterIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
  
  AudioServicesPlaySystemSound(_clickSoundID);
  
  POPSpringAnimation *springAnimation = [_characterCollectionView pop_animationForKey:kCharacterCollectionViewScrollViewAnimationKey];
  if (springAnimation == nil) {
    springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPScrollViewContentOffset];
    [_characterCollectionView pop_addAnimation:springAnimation forKey:kCharacterCollectionViewScrollViewAnimationKey];
  }
  
  springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.bounds.size.height * characterIndex, 0.0)];
}

#pragma mark - Helper Functions
static NSString * characterForIndex(NSUInteger characterIndex, BOOL CAPSLOCK)
{
  char c = 0;
  if (characterIndex < 26) {
    c = [characterLookup characterAtIndex:((CAPSLOCK ? 0 : 26) + characterIndex)];
  } else if (characterIndex < (characterLookup.length - 26)) {
    c = [characterLookup characterAtIndex:characterIndex + 26];
  } else {
    NSRange emojiRange = [emojiLookup rangeOfComposedCharacterSequencesForRange:NSMakeRange((characterIndex - (characterLookup.length - 26)) * 2, 1)];
    return [emojiLookup substringWithRange:emojiRange];
  }
  
  return [NSString stringWithFormat:@"%c", c];
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

#pragma mark - UICollectionViewDataSource
- (NSUInteger)maxCharacters
{
  return (characterLookup.length - 26) + (emojiLookup.length / 2);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.maxCharacters;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCharacterCollectionViewCellReuseIdentifier forIndexPath:indexPath];
  
  UILabel *textLabel = (UILabel *)[cell viewWithTag:0x1337];
  if (textLabel == nil) {
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.bounds.size.width, cell.bounds.size.height)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:18.0];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.tag = 0x1337;
    textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [cell addSubview:textLabel];
    
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    selectedView.backgroundColor = [UIColor darkGrayColor];
    cell.selectedBackgroundView = selectedView;
    
    cell.backgroundColor = [UIColor colorWithRed:0.67 green:0.7 blue:0.74 alpha:1.0];
  }

  cell.selected = (_characterIndex == indexPath.row);
  
  textLabel.text = characterForIndex(indexPath.row, _CAPSLOCKENABLED);

  return cell;
}

- (void)_fixEverythingBecauseImLazy
{
  for (int i = 0; i < characterLookup.length; i++) {
    [_characterCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO];
  }
  [_characterCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_characterIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark - Getters / Setters
- (void)setCAPSLOCKENABLED:(BOOL)CAPSLOCKENABLED
{
  if (_CAPSLOCKENABLED == CAPSLOCKENABLED) {
    return;
  }
  
  _CAPSLOCKENABLED = CAPSLOCKENABLED;
  
  [_characterCollectionView reloadData];
  [self _fixEverythingBecauseImLazy];
}

- (NSString *)currentCharacter
{
  return characterForIndex(_characterIndex, _CAPSLOCKENABLED);
}

@end
