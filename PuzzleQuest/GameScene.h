//
//  GameScene.h
//  PuzzleQuest
//

//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Level;
@class Swap;

@interface GameScene : SKScene

@property (nonatomic, strong) Level *level;
@property (copy, nonatomic) void (^swipeHandler)(Swap *swap);

- (void)addSpritesForCookies:(NSSet *)cookies;
- (void)addTiles;
- (void)animateSwap:(Swap *)swap completion:(dispatch_block_t)completion;

@end
