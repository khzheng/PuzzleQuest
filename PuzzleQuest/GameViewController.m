//
//  GameViewController.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/22/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"
#import "Level.h"
#import "GameScene.h"
#import "Swap.h"
#import "Chain.h"
#import "Hero.h"
#import "Enemy.h"

@interface GameViewController ()
@property (nonatomic, strong) GameView *gameView;

@property (nonatomic, strong) Hero *hero;
@property (nonatomic, strong) Enemy *enemy;
@property (nonatomic, strong) Level *level;
@property (nonatomic, strong) GameScene *scene;
@property (nonatomic, assign) NSUInteger score;
@property (nonatomic, assign) NSUInteger moves;

@property (nonatomic, weak) IBOutlet UILabel *heroHpLabel;
@property (nonatomic, weak) IBOutlet UILabel *movesLabel;
@property (nonatomic, weak) IBOutlet UILabel *enemyHpLabel;
@property (nonatomic, weak) IBOutlet UILabel *gameOverLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)loadView {
    self.gameView = [[GameView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.gameView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view.
    SKView *skView = ((GameView *)self.view).skView;
    skView.multipleTouchEnabled = NO;
    
    // Create and configure scene
    self.scene = [GameScene sceneWithSize:skView.bounds.size];
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
//                self.view.userInteractionEnabled = YES;
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
    [self beginGame];

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
    
    if (self.enemy)
        [self.enemy decrementAttackTurn];
    
    if (self.enemy && self.enemy.currentHp <= 0) {
        NSLog(@"Hero killed enemy! Gained %lu xp.", [self.enemy xp]);
        
        [self.hero awardXp:[self.enemy xp]];
        
        // generate new enemy
        self.enemy = [[Enemy alloc] init];
    }
    
    [self updateLabels];
    
    if (self.enemy && self.enemy.currentAttackTurns == 0) {
        [self.hero takeDamage:self.enemy.attack];
        [self.enemy refreshAttackTurns];
        [self updateLabels];
        
        NSLog(@"Enemy attacks Hero for %ld damage!", self.enemy.attack);
    }
    
    if (self.hero.currentHp <= 0) {
        self.gameOverLabel.text = @"You Died!";
        [self showGameOver];
    }
}

- (void)updateLabels {
    double heroHpPercentage = self.hero.currentHp / (double)self.hero.maxHp;
    self.gameView.hpBar.percentage = heroHpPercentage;
    self.gameView.hpBar.displayString = [NSString stringWithFormat:@"%ld/%ld", self.hero.currentHp, self.hero.maxHp];
    
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
    NSSet *chains = [self.level removeMatches];
    
    if ([chains count] == 0) {
        [self.level.movedCookies removeAllObjects];
        [self beginNextTurn];
        return;
    }
    
    [self.scene animateMatchedCookies:chains completion:^{
        NSUInteger score = 0;
        
        // tally points (swords, shields, health, and gold)
        NSInteger attack = 0;
        NSInteger shield = 0;
        NSInteger health = 0;
        NSInteger gold = 0;
        for (Chain *chain in chains) {
            CookieType type = [chain cookieType];
            switch (type) {
                case SwordType:
                    attack += chain.score;
                    break;
                case ShieldType:
                    shield += chain.score;
                    break;
                case HeartType:
                    health += chain.score;
                    break;
                case GoldType:
                    gold += chain.score;
                    break;
                default:
                    break;
            }
            
            self.score += chain.score;
            score += chain.score;
        }
        
        // apply points
        if (attack > 0) {
            if (self.enemy) {
                [self.enemy takeDamage:attack];
                NSLog(@"Hero attacks enemy for %ld damage!", attack);
            }
        }
        if (shield > 0) {
            
        }
        if (health > 0) {
            NSInteger healAmount = [self.hero heal:health];
            if (healAmount > 0)
                NSLog(@"Hero heals for %ld health!", healAmount);
        }
        if (gold < 0) {
            
        }
        
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
