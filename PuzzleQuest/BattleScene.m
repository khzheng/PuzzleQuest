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
@property (nonatomic, strong) SKNode *enemyLayer;
@property (nonatomic, strong) SKSpriteNode *heroSprite;
@property (nonatomic, strong) SKSpriteNode *enemySprite;
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
        
        _enemyLayer = [SKNode node];
        [_baseLayer addChild:_enemyLayer];
    }
    
    return self;
}

- (void)loadHero {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Warrior"];
    sprite.position = CGPointMake(-36, -15);
    self.heroSprite = sprite;
    [self.heroLayer addChild:sprite];
}

- (void)loadNextEnemy {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Zombie"];
    sprite.position = CGPointMake(36, -13);
    self.enemySprite = sprite;
    [self.enemyLayer addChild:sprite];
}

- (void)heroAttackEnemy {
    [self.heroSprite runAction:[SKAction sequence:@[[SKAction moveByX:10 y:0 duration:0.1],
                                                   [SKAction moveByX:-10 y:0 duration:0.3]]]];
    [self.enemySprite runAction:[SKAction sequence:@[[SKAction hide],
                                                     [SKAction waitForDuration:0.3],
                                                     [SKAction unhide],
                                                     [SKAction waitForDuration:0.2],
                                                     [SKAction hide],
                                                     [SKAction waitForDuration:0.2],
                                                     [SKAction unhide],
                                                     [SKAction waitForDuration:0.1],
                                                     [SKAction hide],
                                                     [SKAction waitForDuration:0.1],
                                                     [SKAction unhide]]]];
}

- (void)killEnemy {
    [self.enemySprite runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:1.0], [SKAction removeFromParent]]] completion:^{
        [self performSelector:@selector(loadNextEnemy) withObject:nil afterDelay:1.0];
    }];
}

@end
