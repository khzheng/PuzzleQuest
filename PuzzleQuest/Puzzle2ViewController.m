//
//  Puzzle2ViewController.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 5/7/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "Puzzle2ViewController.h"
#import "Puzzle2View.h"

@interface Puzzle2ViewController ()
@property (nonatomic, strong) Puzzle2View *puzzleView;
@end

@implementation Puzzle2ViewController

- (void)loadView {
    self.puzzleView = [[Puzzle2View alloc] initWithFrame:CGRectZero];
    self.view = self.puzzleView;
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
