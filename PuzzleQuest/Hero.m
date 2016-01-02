//
//  Hero.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 1/2/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "Hero.h"

#define INITIAL_HP  10

@implementation Hero

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _maxHp = _currentHp = INITIAL_HP;
    }
    
    return self;
}

- (void)takeDamage:(NSInteger)damage {
    _currentHp -= damage;
}

- (void)reset {
    _maxHp = _currentHp = INITIAL_HP;
}

@end
