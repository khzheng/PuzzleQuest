//
//  GameViewController.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 5/7/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"
#import "BattleViewController.h"
#import "Hero.h"

@interface GameViewController ()
@property (nonatomic, strong) GameView *gameView;

@property (nonatomic, strong) PuzzleViewController *puzzleViewController;
@property (nonatomic, strong) BattleViewController *battleViewController;

@property (nonatomic, strong) Hero *hero;
@end

@implementation GameViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hero = [[Hero alloc] init];
        
        _puzzleViewController = [[PuzzleViewController alloc] init];
        _battleViewController = [[BattleViewController alloc] initWithHero:self.hero];
    }
    
    return self;
}

- (void)loadView {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    self.gameView = [[GameView alloc] initWithFrame:bounds];
    
    self.puzzleViewController.view.frame = CGRectMake(0,
                                                      bounds.size.height - bounds.size.width,
                                                      bounds.size.width,
                                                      bounds.size.width);
    
    self.battleViewController.view.frame = CGRectMake(0,
                                                      0,
                                                      bounds.size.width,
                                                      bounds.size.height - bounds.size.width);
    
    [self.gameView addSubview:self.puzzleViewController.view];
    [self.gameView addSubview:self.battleViewController.view];
    
    self.view = self.gameView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.puzzleViewController.delegate = self;
    [self.puzzleViewController beginGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PuzzleViewControllerDelegate

- (void)puzzleViewController:(PuzzleViewController *)puzzleViewController
               matchedSwords:(NSInteger)swords
                     shields:(NSInteger)shields
                      hearts:(NSInteger)hearts
                       coins:(NSInteger)coins {
    NSLog(@"matched swords: %ld shields: %ld, hearts: %ld, coins: %ld", swords, shields, hearts, coins);
    
    if (swords > 0) {
        [self.hero gainAttMeter:swords];
        
//        NSLog(@"hero ATT Meter %d/%d", self.hero.currentAttMeter, self.hero.maxAttMeter);
        
        if (self.hero.currentAttMeter >= self.hero.maxAttMeter) {
            [self.hero consumeAttMeter];
            [self.battleViewController heroAttackEnemy];
        }
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
