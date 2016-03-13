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
    GoldType
};

static const NSUInteger NumberCookieTypes = 4;

@interface Cookie : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) CookieType cookieType;
@property (strong, nonatomic) SKSpriteNode *sprite;
@property (assign, nonatomic) BOOL isSpecial;

- (BOOL)isEqualToCookie:(Cookie *)cookie;

- (NSString *)spriteName;
- (NSString *)highlightedSpriteName;
- (NSString *)specialSpriteName;

@end
