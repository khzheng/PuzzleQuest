//
//  GameViewController.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/22/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import "GameViewController.h"
#import "Level.h"
#import "GameScene.h"
#import "Swap.h"
#import "Chain.h"
#import "Hero.h"

@interface GameViewController ()
@property (nonatomic, strong) Hero *hero;
@property (nonatomic, strong) Level *level;
@property (nonatomic, strong) GameScene *scene;
@property (nonatomic, assign) NSUInteger score;
@property (nonatomic, assign) NSUInteger moves;

@property (nonatomic, weak) IBOutlet UILabel *heroHpLabel;
@property (nonatomic, weak) IBOutlet UILabel *movesLabel;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view.
    SKView *skView = (SKView *)self.view;
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
    
    if (self.moves % 4 == 0)
        [self.hero takeDamage:1];
    
    [self updateLabels];
    
    if (self.hero.currentHp <= 0) {
        self.gameOverLabel.text = @"You Died!";
        [self showGameOver];
    }
}

- (void)updateLabels {
    self.heroHpLabel.text = [NSString stringWithFormat:@"%lu", (long) self.hero.currentHp];
    self.movesLabel.text = [NSString stringWithFormat:@"%lu", (long) self.moves];
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
        for (Chain *chain in chains) {
            self.score += chain.score;
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

- (IBAction)shuffleButtonPressed:(id)sender {
    [self shuffle];
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

@end
