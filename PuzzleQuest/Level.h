//
//  Level.h
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/22/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cookie;
@class Tile;
@class Swap;
@class Chain;

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface Level : NSObject

@property (nonatomic, strong) NSMutableSet *movedCookies;
@property (nonatomic, readonly) NSMutableSet *enemyCookies;

- (NSSet *)shuffle;
- (Cookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row;
- (Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
- (void)performSwap:(Swap *)swap;
- (BOOL)isPossibleSwap:(Swap *)swap;
- (NSSet *)removeMatches;
- (NSArray *)fillHoles;
- (NSArray *)topUpCookies;
- (void)detectPossibleSwaps;
- (void)detectEnemyCookies;
- (void)decrementAllEnemyAttackCounters;
- (NSArray *)enemiesReadyToAttack;
- (NSArray *)enemiesAttack;
- (void)resetEnemyAttackCounters:(NSArray *)enemies;

@end
