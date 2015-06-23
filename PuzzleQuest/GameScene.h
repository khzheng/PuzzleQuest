//
//  GameScene.h
//  PuzzleQuest
//

//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Level;

@interface GameScene : SKScene

@property (nonatomic, strong) Level *level;

- (void)addSpritesForCookies:(NSSet *)cookies;

@end
