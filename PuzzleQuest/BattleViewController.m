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

@interface BattleViewController ()
@property (nonatomic, strong) BattleView *battleView;
@property (nonatomic, strong) BattleScene *battleScene;
@end

@implementation BattleViewController

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
    [self.battleScene loadNextEnemy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
