//
//  BattleScene.h
//  PuzzleQuest
//
//  Created by Ken Zheng on 5/7/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BattleScene : SKScene

- (void)loadHero;
- (void)loadNextEnemy;

- (void)heroAttackEnemy;
- (void)killEnemy;

@end
