//
//  Enemy.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 1/2/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "Enemy.h"
#define INITIAL_HP  10
#define INITIAL_ATTACK_TURNS    2

@implementation Enemy

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _maxHp = INITIAL_HP;
        _currentHp = INITIAL_HP;
        _attack = 2;
        _attackTurns = _currentAttackTurns = INITIAL_ATTACK_TURNS;
        _xp = 1;
    }
    
    return self;
}

- (void)decrementAttackTurn {
    _currentAttackTurns -= 1;
}

- (void)refreshAttackTurns {
    _currentAttackTurns = _attackTurns;
}

- (BOOL)takeDamage:(NSInteger)damage {
    _currentHp -= damage;
    
    return _currentHp <= 0;
}

@end
