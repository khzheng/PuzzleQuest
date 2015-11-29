//
//  Level.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/22/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import "Level.h"
#import "Cookie.h"
#import "Tile.h"
#import "Swap.h"
#import "Chain.h"

@interface Level ()
@property (nonatomic, strong) NSSet *possibleSwaps;
@end

@implementation Level {
    Cookie *_cookies[NumColumns][NumRows];  // keeps track of Cookie objects
    Tile *_tiles[NumColumns][NumRows];      // keeps track of which tiles are empty or contain a Cookie
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _movedCookies = [[NSMutableSet alloc] init];
        
        // create tiles
        for (NSInteger row = 0; row < NumRows; row++)
            for (NSInteger column = 0; column < NumColumns; column++)
                _tiles[column][row] = [[Tile alloc] init];
    }
    
    return self;
}

- (NSSet *)shuffle {
    NSSet *set;
    do {
        set = [self createInitialCookies];
        
        [self detectPossibleSwaps];
        
        NSLog(@"possible swaps: %@", self.possibleSwaps);
    } while ([self.possibleSwaps count] == 0);
    
    for (NSInteger column = 0; column < NumColumns; column++) {
        NSLog(@"cookie(%lu, 0) type: %lu, exists? %d", (long)column, (unsigned long)_cookies[column][0].cookieType, _cookies[column][0] != nil);
    }
    
    return set;
}

- (Cookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return _cookies[column][row];
}

- (Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return _tiles[column][row];
}

- (void)performSwap:(Swap *)swap {
    // tmp store columns, rows
    NSInteger columnA = swap.cookieA.column;
    NSInteger rowA = swap.cookieA.row;
    NSInteger columnB = swap.cookieB.column;
    NSInteger rowB = swap.cookieB.row;
    
    // swap column, row and update _cookies array
    
    _cookies[columnA][rowA] = swap.cookieB;
    swap.cookieB.column = columnA;
    swap.cookieB.row = rowA;
    
    _cookies[columnB][rowB] = swap.cookieA;
    swap.cookieA.column = columnB;
    swap.cookieA.row = rowB;
    
    [self.movedCookies addObject:swap.cookieA];
    [self.movedCookies addObject:swap.cookieB];
    
    NSLog(@"movedCookies: %@", self.movedCookies);
}

#pragma mark - Helper methods

- (NSSet *)createInitialCookies {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            if (_tiles[column][row] != nil) {   // make sure a tile is there
                // ensures that there are no initial matches
                NSInteger cookieType;
                do {
                    cookieType = arc4random_uniform(NumberCookieTypes) + 1;
                } while((column >= 2 &&
                         _cookies[column - 1][row].cookieType == cookieType &&
                         _cookies[column - 2][row].cookieType == cookieType)
                        ||
                        (row >= 2 &&
                         _cookies[column][row - 1].cookieType == cookieType &&
                         _cookies[column][row - 2].cookieType == cookieType));
                
                Cookie *cookie = [self createCookitAtColumn:column row:row withType:cookieType];
                
                [set addObject:cookie];
            }
        }
    }
    
    return set;
}

- (Cookie *)createCookitAtColumn:(NSInteger)column row:(NSInteger)row withType:(NSUInteger)cookieType {
    Cookie *cookie = [[Cookie alloc] init];
    cookie.cookieType = cookieType;
    cookie.row = row;
    cookie.column = column;
    cookie.isSpecial = NO;
    _cookies[column][row] = cookie;
    return cookie;
}

// this steps thru the grid and swap each cookie with the one next to it, once horizontally and then vertically
- (void)detectPossibleSwaps {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            Cookie *cookie = _cookies[column][row];
            if (cookie != nil) {
                if (column < NumColumns - 1) {  // is it possible to swap this cookie with the one on the right?
                    Cookie *otherCookie = _cookies[column + 1][row];
                    if (otherCookie != nil) {
                        // swap them
                        _cookies[column][row] = otherCookie;
                        _cookies[column + 1][row] = cookie;
                        
                        // is either cookie part of a chain?
                        if ([self hasChainAtColumn:column + 1 row:row] ||
                            [self hasChainAtColumn:column row:row]) {
                            
                            Swap *swap = [[Swap alloc] init];
                            swap.cookieA = cookie;
                            swap.cookieB = otherCookie;
                            [set addObject:swap];
                        }
                        
                        // swap them back
                        _cookies[column][row] = cookie;
                        _cookies[column + 1][row] = otherCookie;
                    }
                }
                
                if (row < NumRows - 1) {
                    Cookie *otherCookie = _cookies[column][row + 1];
                    if (otherCookie != nil) {
                        // swap them
                        _cookies[column][row] = otherCookie;
                        _cookies[column][row + 1] = cookie;
                        
                        if ([self hasChainAtColumn:column row:row + 1] ||
                            [self hasChainAtColumn:column row:row]) {
                            
                            Swap *swap = [[Swap alloc] init];
                            swap.cookieA = cookie;
                            swap.cookieB = otherCookie;
                            [set addObject:swap];
                        }
                        
                        // swap them back
                        _cookies[column][row] = cookie;
                        _cookies[column][row + 1] = otherCookie;
                    }
                }
            }
        }
    }
    
    self.possibleSwaps = set;
}

// a chain is 3 or more consecutive cookies of the same type in a row or column
- (BOOL)hasChainAtColumn:(NSInteger)column row:(NSInteger)row {
    NSUInteger cookieType = ((Cookie *)_cookies[column][row]).cookieType;
    
    NSUInteger horizontalLength = 1;
    for (NSInteger i = column - 1; i >= 0 && _cookies[i][row].cookieType == cookieType; i--, horizontalLength++);
    for (NSInteger i = column + 1; i < NumColumns && _cookies[i][row].cookieType == cookieType; i++, horizontalLength++);
    if (horizontalLength >= 3)  return YES;
    
    NSUInteger verticalLength = 1;
    for (NSInteger i = row - 1; i >= 0 && _cookies[column][i].cookieType == cookieType; i--, verticalLength++);
    for (NSInteger i = row + 1; i < NumRows && _cookies[column][i].cookieType == cookieType; i++, verticalLength++);
    return (verticalLength >= 3);
}

- (BOOL)isPossibleSwap:(Swap *)swap {
    return [self.possibleSwaps containsObject:swap];
}

- (NSSet *)detectHorizontalMatches {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns - 2; ) {
            if (_cookies[column][row] != nil) {
                NSUInteger matchType = _cookies[column][row].cookieType;
                if (_cookies[column + 1][row].cookieType == matchType &&
                    _cookies[column + 2][row].cookieType == matchType) {
                    
                    Chain *chain = [[Chain alloc] init];
                    chain.chainType = ChainTypeHorizontal;
                    do {
                        _cookies[column][row].isSpecial = NO;
                        [chain addCookie:_cookies[column][row]];
                        column++;
                    }
                    while (column < NumColumns && _cookies[column][row].cookieType == matchType);
                    
                    if ([chain count] == 4) {
                        // look for special cookies
                        for (Cookie *cookie in chain.cookies) {
                            if ([self.movedCookies containsObject:cookie]) {
                                cookie.isSpecial = YES;
                                
                                // add special sprite
                                SKTexture *texture = [SKTexture textureWithImageNamed:[cookie specialSpriteName]];
                                SKSpriteNode *specialSprite = [SKSpriteNode node];
                                specialSprite.size = texture.size;
                                [specialSprite runAction:[SKAction setTexture:texture]];
                                
                                [cookie.sprite addChild:specialSprite];
                                specialSprite.alpha = 1.0;
                            }
                        }
                    } else if ([chain count] >= 5) {
                        // middle cookie becomes special
                        Cookie *specialCookie = chain.cookies[2];
                        specialCookie.isSpecial = YES;
                        
                        // add special sprite
                        SKTexture *texture = [SKTexture textureWithImageNamed:[specialCookie specialSpriteName]];
                        SKSpriteNode *specialSprite = [SKSpriteNode node];
                        specialSprite.size = texture.size;
                        [specialSprite runAction:[SKAction setTexture:texture]];
                        
                        [specialCookie.sprite addChild:specialSprite];
                        specialSprite.alpha = 1.0;
                    }
                    
                    [set addObject:chain];
                    continue;
                }
            }
            
            column += 1;
        }
    }
    
    return set;
}

- (NSSet *)detectVerticalMatches {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger column = 0; column < NumColumns; column++) {
        for (NSInteger row = 0; row < NumRows - 2; ) {
            if (_cookies[column][row] != nil) {
                NSUInteger matchType = _cookies[column][row].cookieType;
                if (_cookies[column][row + 1].cookieType == matchType &&
                    _cookies[column][row + 2].cookieType == matchType) {
                    
                    Chain *chain = [[Chain alloc] init];
                    chain.chainType = ChainTypeVertical;
                    do {
                        _cookies[column][row].isSpecial = NO;
                        [chain addCookie:_cookies[column][row]];
                        row++;
                    }
                    while (row < NumRows && _cookies[column][row].cookieType == matchType);
                    
                    if ([chain count] == 4) {
                        // look for special cookies
                        for (Cookie *cookie in chain.cookies) {
                            if ([self.movedCookies containsObject:cookie]) {
                                cookie.isSpecial = YES;
                                
                                // add special sprite
                                SKTexture *texture = [SKTexture textureWithImageNamed:[cookie specialSpriteName]];
                                SKSpriteNode *specialSprite = [SKSpriteNode node];
                                specialSprite.size = texture.size;
                                [specialSprite runAction:[SKAction setTexture:texture]];
                                
                                [cookie.sprite addChild:specialSprite];
                                specialSprite.alpha = 1.0;
                            }
                        }
                    } else if ([chain count] >= 5) {
                        // middle cookie becomes special
                        Cookie *specialCookie = chain.cookies[2];
                        specialCookie.isSpecial = YES;
                        
                        // add special sprite
                        SKTexture *texture = [SKTexture textureWithImageNamed:[specialCookie specialSpriteName]];
                        SKSpriteNode *specialSprite = [SKSpriteNode node];
                        specialSprite.size = texture.size;
                        [specialSprite runAction:[SKAction setTexture:texture]];
                        
                        [specialCookie.sprite addChild:specialSprite];
                        specialSprite.alpha = 1.0;
                    }
                    
                    [set addObject:chain];
                    continue;
                }
            }
            
            row += 1;
        }
    }
    
    return set;
}

- (NSSet *)removeMatches {
    NSSet *horizontalMatches = [self detectHorizontalMatches];
    NSSet *verticalMatches = [self detectVerticalMatches];
    
    
    [self removeCookies:horizontalMatches];
    [self removeCookies:verticalMatches];
//    NSLog(@"Horizontal matches: %@", horizontalMatches);
//    NSLog(@"Vertical matches: %@", verticalMatches);
    
    return [horizontalMatches setByAddingObjectsFromSet:verticalMatches];
}

- (NSArray *)fillHoles {
    NSMutableArray *columns = [NSMutableArray array];
    
    // loop thru each col and each row
    for (NSInteger column = 0; column < NumColumns; column++) {
        NSMutableArray *array;
        for (NSInteger row = 0; row < NumRows; row++) {
            // until we find an empty tile
            if (_tiles[column][row] != nil && _cookies[column][row] == nil) {
                // loop thru above rows until we find a cookie
                for (NSInteger lookup = row + 1; lookup < NumRows; lookup++) {
                    Cookie *cookie = _cookies[column][lookup];
                    
                    if (cookie != nil) {
                        // move the cookie down
                        _cookies[column][row] = cookie;
                        _cookies[column][lookup] = nil;
                        cookie.row = row;
                        
                        // each column gets its own array and cookies that are lower on the screen are first in
                        // we keep this order intact so animation code can apply the correct delay
                        if (array == nil) {
                            array = [NSMutableArray array];
                            [columns addObject:array];
                        }
                        [array addObject:cookie];
                        
                        break;
                    }
                }
            }
        }
    }
    
    return columns;
}

- (NSArray *)topUpCookies {
    NSMutableArray *columns = [NSMutableArray array];
    
    NSUInteger cookieType = 0;
    
    for (NSInteger column = 0; column < NumColumns; column++) {
        NSMutableArray *array;
        for (NSInteger row = NumRows - 1; row > 0 && _cookies[column][row] == nil; row--) {
            // make sure tile is there
            if (_tiles[column][row] != nil) {
                
                // create new cookie type, try to mix it up
                NSUInteger newCookieType;
                do {
                    newCookieType = arc4random_uniform(NumberCookieTypes) + 1;
                } while (newCookieType == cookieType);
                cookieType = newCookieType;
                
                Cookie *cookie = [self createCookitAtColumn:column row:row withType:cookieType];
                
                if (array == nil) {
                    array = [NSMutableArray array];
                    [columns addObject:array];
                }
                [array addObject:cookie];
            }
        }
    }
    
    return columns;
}

- (void)removeCookies:(NSSet *)chains {
    for (Chain *chain in chains)
        for (Cookie *cookie in chain.cookies)
            if (!cookie.isSpecial)
                _cookies[cookie.column][cookie.row] = nil;
}

@end
