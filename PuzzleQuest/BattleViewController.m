//
//  BattleViewController.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 5/7/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "BattleViewController.h"
#import "BattleView.h"
#import "BattleScene.h"
#import "Enemy.h"

@interface BattleViewController ()
@property (nonatomic, strong) BattleView *battleView;
@property (nonatomic, strong) BattleScene *battleScene;
@property (nonatomic, strong) Enemy *currentEnemy;
@end

@implementation BattleViewController

- (instancetype)initWithHero:(Hero *)hero {
    self = [super init];
    if (self) {
        _hero = hero;
    }
    
    return self;
}

- (void)loadView {
    self.battleView = [[BattleView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    self.view = self.battleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKView *skView = self.battleView.skView;
    skView.multipleTouchEnabled = NO;
    
    self.battleScene = [BattleScene sceneWithSize:skView.bounds.size];
    self.battleScene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:self.battleScene];
    
    [self.battleScene loadHero];
    
    self.currentEnemy = [self createNextEnemy];
    [self.battleScene loadNextEnemy];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (Enemy *)createNextEnemy {
    return [[Enemy alloc] init];
}

- (void)heroAttackEnemy {
    BOOL didKill = [self.currentEnemy takeDamage:self.hero.attack];
    
    [self.battleScene heroAttackEnemy];
    
    if (didKill) {
        NSLog(@"Enemy killed!");
        
        [self.battleScene killEnemy];
        
        self.currentEnemy = [self createNextEnemy];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
