//
//  Cookie.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/22/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import "Cookie.h"

@implementation Cookie

- (void)setIsSpecial:(BOOL)isSpecial {
    if (_isSpecial == isSpecial)
        return;
    
    _isSpecial = isSpecial;
    
    if (_isSpecial) {
        SKTexture *texture = [SKTexture textureWithImageNamed:[self specialSpriteName]];
        SKSpriteNode *specialSprite = [SKSpriteNode node];
        specialSprite.size = texture.size;
        [specialSprite runAction:[SKAction setTexture:texture]];
        [self.sprite addChild:specialSprite];
        specialSprite.alpha = 1.0;
    }
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;
    
    if (![object isKindOfClass:[Cookie class]])
        return NO;
    
    return [self isEqualToCookie:(Cookie *)object];
}

- (BOOL)isEqualToCookie:(Cookie *)cookie {
    if (!cookie)
        return NO;
    
    BOOL haveEqualColumns = self.column == cookie.column;
    BOOL haveEqualRows = self.row == cookie.row;
    BOOL haveEqualCookieTypes = self.cookieType == cookie.cookieType;
    BOOL haveEqualIsSpecial = self.isSpecial == cookie.isSpecial;
    
    return haveEqualColumns && haveEqualRows && haveEqualCookieTypes && haveEqualIsSpecial;
}

- (NSString *)spriteName {
    static NSString * const spriteNames[] = {
        @"Sword",
        @"Shield",
        @"Heart",
        @"Gold",
        @"Mana",
        @"Skull",
        @"Croissant",
        @"Cupcake",
        @"Danish",
        @"Donut",
        @"Macaroon",
        @"SugarCookie",
    };
    
    return spriteNames[self.cookieType - 1];
}

- (NSString *)highlightedSpriteName {
    static NSString * const highlightedSpriteNames[] = {
        @"Sword-Highlighted",
        @"Shield-Highlighted",
        @"Heart-Highlighted",
        @"Gold-Highlighted",
        @"Mana-HIghlighted",
        @"Macaroon-Highlighted",
        @"SugarCookie-Highlighted",
    };
    
    return highlightedSpriteNames[self.cookieType - 1];
}

- (NSString *)specialSpriteName {
    static NSString * const specialSpriteNames[] = {
        @"Sword",
        @"Shield",
        @"Heart",
        @"Gold",
        @"Mana",
        @"Skull",
        @"Croissant-special",
        @"Cupcake-special",
        @"Danish-special",
        @"Donut-special",
        @"Macaroon-special",
        @"SugarCookie-special",
    };
    
    return specialSpriteNames[self.cookieType - 1];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"type:%ld square:(%ld,%ld)", (long)self.cookieType,
            (long)self.column, (long)self.row];
}

@end
