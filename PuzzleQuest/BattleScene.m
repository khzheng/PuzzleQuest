//
//  BattleScene.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 5/7/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "BattleScene.h"

@interface BattleScene()
@property (nonatomic, strong) SKNode *baseLayer;
@property (nonatomic, strong) SKNode *heroLayer;
@end

@implementation BattleScene

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"BattleBackground"];
        [self addChild:background];
        
        _baseLayer = [SKNode node];
        [self addChild:_baseLayer];
        
        _heroLayer = [SKNode node];
        [_baseLayer addChild:_heroLayer];
    }
    
    return self;
}

- (void)loadHero {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Warrior"];
    sprite.position = CGPointMake(-36, -15);
    [self.heroLayer addChild:sprite];
}

@end
