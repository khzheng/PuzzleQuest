//
//  Hero.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 1/2/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "Hero.h"

#define INITIAL_HP  30
#define INITIAL_ATK 5

@implementation Hero

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _maxHp = _currentHp = INITIAL_HP;
        _attack = INITIAL_ATK;
        _xp = 0;
        _maxAttMeter = 10;
        _currentAttMeter = 0;
    }
    
    return self;
}

- (void)takeDamage:(NSInteger)damage {
    _currentHp -= damage;
}

- (NSInteger)heal:(NSInteger)healAmount {
    if (healAmount <= 0)
        return 0;
    
    if (self.currentHp + healAmount > self.maxHp) {
        healAmount = self.maxHp - self.currentHp;
    }
    
    _currentHp += healAmount;
    
    return healAmount;
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

- (void)gainAttMeter:(NSInteger)gainedAttMeter {
    _currentAttMeter += gainedAttMeter;
}

- (void)consumeAttMeter {
    _currentAttMeter = 0;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Hero> LVL: %lu, HP: %ld/%lu, ATT: %lu, XP: %lu", [self level], _currentHp, _maxHp, _attack, _xp];
}

@end
