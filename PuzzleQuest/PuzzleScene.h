//
//  GameScene.h
//  PuzzleQuest
//

//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Level;
@class Swap;
@class Cookie;

@interface PuzzleScene : SKScene

@property (nonatomic, strong) Level *level;
@property (copy, nonatomic) void (^swipeHandler)(Swap *swap);

- (void)addSpritesForCookies:(NSSet *)cookies;
- (void)addTiles;
- (void)animateSwap:(Swap *)swap completion:(dispatch_block_t)completion;
- (void)animateInvalidSwap:(Swap *)swap completion:(dispatch_block_t)completion;
- (void)animateMatchedCookies:(NSSet *)chains completion:(dispatch_block_t)completion;
- (void)animateFallingCookies:(NSArray *)columns completion:(dispatch_block_t)completion;
- (void)animateNewCookies:(NSArray *)columns completion:(dispatch_block_t)completion;
- (void)animateAttackCountersForCookies:(NSSet *)cookies completion:(dispatch_block_t)completion;
- (void)showTargetIndicatorForCookie:(Cookie *)cookie;
- (void)removeAllCookieSprites;

@end
