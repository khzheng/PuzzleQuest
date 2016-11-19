//
//  BattleViewController.h
//  PuzzleQuest
//
//  Created by Ken Zheng on 5/7/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hero.h"

@interface BattleViewController : UIViewController

@property (nonatomic, strong) Hero *hero;

- (instancetype)initWithHero:(Hero *)hero;
- (void)heroAttackEnemy;

@end
