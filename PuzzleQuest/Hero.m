//
//  Hero.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 1/2/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "Hero.h"

#define INITIAL_HP  10
#define INITIAL_ATK 1

@implementation Hero

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _maxHp = _currentHp = INITIAL_HP;
        _attack = INITIAL_ATK;
        _xp = 0;
    }
    
    return self;
}

- (void)takeDamage:(NSInteger)damage {
    _currentHp -= damage;
}

- (void)reset {
    _maxHp = _currentHp = INITIAL_HP;
}

- (void)awardXp:(NSUInteger)xp {
    NSUInteger currentLevel = [self level];
    
    _xp += xp;
    
    NSUInteger newLevel = [self level];
    if (newLevel != currentLevel) {
        NSLog(@"Hero leveled up! LVL %lu -> %lu", currentLevel, newLevel);
        // TODO: actually level up
    }
}

- (NSUInteger)level {
    const float constant = 1.0;
    
    return (NSUInteger)(constant * sqrt(_xp));
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Hero> LVL: %lu, HP: %ld/%lu, ATT: %lu, XP: %lu", [self level], _currentHp, _maxHp, _attack, _xp];
}

@end
