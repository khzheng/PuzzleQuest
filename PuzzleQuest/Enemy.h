//
//  Enemy.h
//  PuzzleQuest
//
//  Created by Ken Zheng on 1/2/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Enemy : NSObject

@property (nonatomic, readonly) NSUInteger maxHp;
@property (nonatomic, readonly) NSInteger currentHp;
@property (nonatomic, readonly) NSUInteger attack;
@property (nonatomic, readonly) NSUInteger attackTurns;
@property (nonatomic, readonly) NSUInteger currentAttackTurns;

- (void)decrementAttackTurn;
- (void)refreshAttackTurns;
- (void)takeDamage:(NSInteger)damage;

@end
