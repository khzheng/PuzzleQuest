//
//  GameScene.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/22/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import "GameScene.h"
#import "Level.h"
#import "Cookie.h"

static const CGFloat TileWidth = 32.0;
static const CGFloat TileHeight = 36.0;

@interface GameScene ()
// base layer for all other layers, is centered on screen
@property (strong, nonatomic) SKNode *gameLayer;
// cookies get added here
@property (strong, nonatomic) SKNode *cookiesLayer;
@end

@implementation GameScene

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
        [self addChild:background];
        
        self.gameLayer = [SKNode node];
        [self addChild:self.gameLayer];
        
        CGPoint layerPosition = CGPointMake(-TileWidth * NumColumns / 2, -TileHeight * NumRows / 2);
        
        self.cookiesLayer = [SKNode node];
        self.cookiesLayer.position = layerPosition;
        
        [self.gameLayer addChild:self.cookiesLayer];
    }
    
    return self;
}

- (void)addSpritesForCookies:(NSSet *)cookies {
    for (Cookie *cookie in cookies) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:[cookie spriteName]];
        sprite.position = [self pointForColumn:cookie.column row:cookie.row];
        [self.cookiesLayer addChild:sprite];
        cookie.sprite = sprite;
    }
}

#pragma mark - Helper methods

// returns center
- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row {
    return CGPointMake(column * TileWidth + TileWidth/2, row * TileHeight + TileHeight/2);
}

//-(void)didMoveToView:(SKView *)view {
//    /* Setup your scene here */
//    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    
//    myLabel.text = @"Hello, World!";
//    myLabel.fontSize = 65;
//    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                   CGRectGetMidY(self.frame));
//    
//    [self addChild:myLabel];
//}
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.xScale = 0.5;
//        sprite.yScale = 0.5;
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
//}
//
//-(void)update:(CFTimeInterval)currentTime {
//    /* Called before each frame is rendered */
//}

@end
