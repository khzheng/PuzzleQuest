//
//  Hero.h
//  PuzzleQuest
//
//  Created by Ken Zheng on 1/2/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hero : NSObject

@property (nonatomic, assign, readonly) NSUInteger maxHp;
@property (nonatomic, assign, readonly) NSInteger currentHp;
@property (nonatomic, assign, readonly) NSUInteger attack;
@property (nonatomic, assign, readonly) NSUInteger xp;

- (void)takeDamage:(NSInteger)damage;
- (NSInteger)heal:(NSInteger)healAmount;
- (void)reset;
- (void)awardXp:(NSUInteger)xp;
- (NSUInteger)level;

@end
