//
//  Cookie.h
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/22/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@import SpriteKit;

typedef NS_ENUM(NSInteger, CookieType) {
    SwordType = 1,
    ShieldType,
    HeartType,
    GoldType,
    ManaType,
    SkullType
};

static const NSUInteger NumberCookieTypes = 5;

@interface Cookie : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) CookieType cookieType;
@property (strong, nonatomic) SKSpriteNode *sprite;
@property (nonatomic, strong) SKLabelNode *attackTurnsCounterLabel;
@property (assign, nonatomic) BOOL isSpecial;
@property (nonatomic, assign) NSUInteger maxHp;
@property (nonatomic, assign) NSInteger currentHp;
@property (nonatomic, assign) NSUInteger attack;
@property (nonatomic, assign) NSUInteger attackTurns;
@property (nonatomic, assign) NSInteger attackTurnsCounter;

- (BOOL)isEqualToCookie:(Cookie *)cookie;

- (void)decrementAttackTurnsCounter;
- (NSString *)spriteName;
- (NSString *)highlightedSpriteName;
- (NSString *)specialSpriteName;

@end
