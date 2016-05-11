//
//  GameViewController.h
//  PuzzleQuest
//

//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@class PuzzleViewController;

@protocol PuzzleViewControllerDelegate <NSObject>

- (void)puzzleViewController:(PuzzleViewController *)puzzleViewController
               matchedSwords:(NSInteger)swords
                     shields:(NSInteger)shields
                      hearts:(NSInteger)hearts
                       coins:(NSInteger)coins;

@end

@interface PuzzleViewController : UIViewController

@property (nonatomic, weak) id<PuzzleViewControllerDelegate> delegate;

- (void)beginGame;

@end
