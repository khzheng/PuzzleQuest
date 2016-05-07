//
//  GameViewController.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 5/7/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"
#import "PuzzleViewController.h"

@interface GameViewController ()
@property (nonatomic, strong) GameView *gameView;

@property (nonatomic, strong) PuzzleViewController *puzzleViewController;
@end

@implementation GameViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _puzzleViewController = [[PuzzleViewController alloc] init];
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
    
    [self.gameView addSubview:self.puzzleViewController.view];
    
    self.view = self.gameView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.puzzleViewController begin];
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
