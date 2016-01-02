//
//  Enemy.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 1/2/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "Enemy.h"
#define INITIAL_HP  5
#define INITIAL_ATTACK_TURNS    4

@implementation Enemy

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _maxHp = _currentHp = INITIAL_HP;
        _attack = 1;
        _attackTurns = _currentAttackTurns = INITIAL_ATTACK_TURNS;
    }
    
    return self;
}

- (void)decrementAttackTurn {
    _currentAttackTurns -= 1;
}

- (void)refreshAttackTurns {
    _currentAttackTurns = _attackTurns;
}

@end
