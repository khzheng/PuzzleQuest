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
@property (nonatomic, assign, readonly) NSUInteger currentHp;

- (void)takeDamage:(NSInteger)damage;
- (void)reset;

@end
