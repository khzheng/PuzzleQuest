//
//  GameViewController.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 5/7/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"
//#import "PuzzleViewController.h"
#import "Puzzle2ViewController.h"

@interface GameViewController ()
@property (nonatomic, strong) GameView *gameView;

@property (nonatomic, strong) Puzzle2ViewController *puzzleViewController;
@end

@implementation GameViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _puzzleViewController = [[Puzzle2ViewController alloc] init];
    }
    
    return self;
}

- (void)loadView {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    self.gameView = [[GameView alloc] initWithFrame:bounds];
    
    self.puzzleViewController.view.frame = CGRectMake(0, bounds.size.height/2, bounds.size.width, bounds.size.height/2);
    
    [self.gameView addSubview:self.puzzleViewController.view];
    
    self.view = self.gameView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
