//
//  GameViewController.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/22/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import "PuzzleViewController.h"
#import "PuzzleView.h"
#import "Level.h"
#import "PuzzleScene.h"
#import "Swap.h"
#import "Chain.h"
#import "Hero.h"
#import "Enemy.h"

@interface PuzzleViewController ()
@property (nonatomic, strong) PuzzleView *puzzleView;

@property (nonatomic, strong) Hero *hero;
@property (nonatomic, strong) Enemy *enemy;
@property (nonatomic, strong) Level *level;
@property (nonatomic, strong) PuzzleScene *scene;
@property (nonatomic, assign) NSUInteger score;
@property (nonatomic, assign) NSUInteger moves;

@property (nonatomic, weak) IBOutlet UILabel *heroHpLabel;
@property (nonatomic, weak) IBOutlet UILabel *movesLabel;
@property (nonatomic, weak) IBOutlet UILabel *enemyHpLabel;
@property (nonatomic, weak) IBOutlet UILabel *gameOverLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation PuzzleViewController

- (void)loadView {
    self.puzzleView = [[PuzzleView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.puzzleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.puzzleView.shuffleButton addTarget:self action:@selector(shuffleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Configure the view.
    SKView *skView = ((PuzzleView *)self.view).skView;
    skView.multipleTouchEnabled = NO;
    
    // Create and configure scene
    self.scene = [PuzzleScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Load level
    self.level = [[Level alloc] init];
    self.scene.level = self.level;
    
    // Load tiles
    [self.scene addTiles];
    
    id block = ^(Swap *swap) {
        self.view.userInteractionEnabled = NO;

        if ([self.level isPossibleSwap:swap]) {
            [self.level performSwap:swap];
            [self.scene animateSwap:swap completion:^{
                [self handleMatches];
            }];
            
        } else {
            [self.scene animateInvalidSwap:swap completion:^{
                self.view.userInteractionEnabled = YES;
            }];
        }
    };
    
    self.scene.swipeHandler = block;
    
    self.gameOverLabel.hidden = YES;
    
    // Present scene
    [skView presentScene:self.scene];
    
    self.hero = [[Hero alloc] init];
    NSLog(@"Starting Hero: %@", self.hero);
    
    self.enemy = nil;
    
    // start game!
//    [self beginGame];

//    // Configure the view.
//    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
//    /* Sprite Kit applies additional optimizations to improve rendering performance */
//    skView.ignoresSiblingOrder = YES;
//    
//    // Create and configure the scene.
//    // we're not loading from a file
////    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
//    
//    GameScene *scene = [[GameScene alloc] initWithSize:skView.bounds.size];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    
//    // Present the scene.
//    [skView presentScene:scene];
}

- (void)incrementMoves {
    self.moves += 1;
    
    [self updateLabels];
    
    if (self.hero.currentHp <= 0) {
        self.gameOverLabel.text = @"You Died!";
        [self showGameOver];
    }
}

- (void)updateLabels {
    double heroHpPercentage = self.hero.currentHp / (double)self.hero.maxHp;
    self.puzzleView.hpBar.percentage = heroHpPercentage;
    self.puzzleView.hpBar.displayString = [NSString stringWithFormat:@"%ld/%ld", self.hero.currentHp, self.hero.maxHp];
    
    self.heroHpLabel.text = [NSString stringWithFormat:@"%ld", (long) self.hero.currentHp];
    self.movesLabel.text = [NSString stringWithFormat:@"%lu", (long) self.enemy.currentAttackTurns];
    self.enemyHpLabel.text = [NSString stringWithFormat:@"%ld", (long) self.enemy.currentHp];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)beginGame {
    self.score = 0;
    self.moves = 0;
    [self.hero reset];
    self.enemy = [[Enemy alloc] init];
    [self updateLabels];
    
    [self shuffle];
}

- (void)shuffle {
    [self.scene removeAllCookieSprites];
    
    NSSet *newCookies = [self.level shuffle];
    [self.scene addSpritesForCookies:newCookies];
}

- (void)handleMatches {
    static NSInteger swordsMatched = 0;
    static NSInteger shieldsMatched = 0;
    static NSInteger coinsMatched = 0;
    static NSInteger heartsMatched = 0;
    
    NSSet *chains = [self.level removeMatches];
    
    if ([chains count] == 0) {
        [self.delegate puzzleViewController:self
                              matchedSwords:swordsMatched
                                    shields:shieldsMatched
                                     hearts:heartsMatched
                                      coins:coinsMatched];
        
        swordsMatched = shieldsMatched = coinsMatched = heartsMatched = 0;
        
        [self.level.movedCookies removeAllObjects];
        [self beginNextTurn];
        return;
    }
    
    [self.scene animateMatchedCookies:chains completion:^{
        NSUInteger score = 0;
        
        // tally points (swords, shields, hearts, and coins)

        for (Chain *chain in chains) {
            CookieType type = [chain cookieType];
            switch (type) {
                case SwordType:
                    swordsMatched += chain.score;
                    break;
                case ShieldType:
                    shieldsMatched += chain.score;
                    break;
                case HeartType:
                    heartsMatched += chain.score;
                    break;
                case GoldType:
                    coinsMatched += chain.score;
                    break;
                default:
                    break;
            }
            
            self.score += chain.score;
            score += chain.score;
        }
        
//        // apply points
//        if (attack > 0) {
////            if (self.enemy) {
////                [self.enemy takeDamage:attack];
////                NSLog(@"Hero attacks enemy for %ld damage!", attack);
////            }
//        }
//        if (shield > 0) {
//            
//        }
//        if (health > 0) {
//            NSInteger healAmount = [self.hero heal:health];
//            if (healAmount > 0)
//                NSLog(@"Hero heals for %ld health!", healAmount);
//        }
//        if (gold < 0) {
//            
//        }
//        if (skull > 0) {
//            [self.hero takeDamage:skull];
//            NSLog(@"Hero takes %ld damage!", skull);
//        }
        
        [self updateLabels];
        
        NSArray *columns = [self.level fillHoles];
        [self.scene animateFallingCookies:columns completion:^{
            NSArray *columns = [self.level topUpCookies];
            
            [self.scene animateNewCookies:columns completion:^{
                [self handleMatches];
            }];
        }];
    }];
}

- (void)beginNextTurn {
    [self.level detectPossibleSwaps];
    
    [self.level detectEnemyCookies];
    Cookie *targetEnemyCookie = [self.level targetEnemyCookie];
    if (targetEnemyCookie) {
        [self.scene showTargetIndicatorForCookie:targetEnemyCookie];
    }
    
    self.view.userInteractionEnabled = YES;
    
    [self incrementMoves];
}

- (void)showGameOver {
    self.gameOverLabel.hidden = NO;
    self.scene.userInteractionEnabled = NO;
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGameOver)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)hideGameOver {
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer = nil;
    
    self.gameOverLabel.hidden = YES;
    self.scene.userInteractionEnabled = YES;
    
    [self beginGame];
}

#pragma mark - Actions

- (IBAction)shuffleButtonPressed:(id)sender {
    [self shuffle];
}

- (IBAction)heroButtonPressed:(id)sender {
    NSLog(@"%@", self.hero);
}

@end
