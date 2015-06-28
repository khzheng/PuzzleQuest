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
#import "Swap.h"
#import "Chain.h"

static const CGFloat TileWidth = 32.0;
static const CGFloat TileHeight = 36.0;

@interface GameScene ()
@property (strong, nonatomic) SKNode *gameLayer;        // base layer for all other layers, is centered on screen
@property (strong, nonatomic) SKNode *cookiesLayer;     // cookies get added here
@property (strong, nonatomic) SKNode *tilesLayer;       // tiles get added here
@property (assign, nonatomic) NSInteger swipeFromColumn;// records cookie swiped
@property (assign, nonatomic) NSInteger swipeFromRow;   // records cookie swiped
@property (nonatomic, strong) SKSpriteNode *selectionSprite;
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
        
        self.tilesLayer = [SKNode node];
        self.tilesLayer.position = layerPosition;
        [self.gameLayer addChild:self.tilesLayer];
        
        self.cookiesLayer = [SKNode node];
        self.cookiesLayer.position = layerPosition;
        [self.gameLayer addChild:self.cookiesLayer];
        
        self.swipeFromColumn = self.swipeFromRow = NSNotFound;
        self.selectionSprite = [SKSpriteNode node];
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

- (void)addTiles {
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            if ([self.level tileAtColumn:column row:row] != nil) {
                SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Tile"];
                sprite.position = [self pointForColumn:column row:row];
                [self.tilesLayer addChild:sprite];
            }
        }
    }
}

#pragma mark - Touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    // convert touch location to a point relative to cookiesLayer
    CGPoint location = [touch locationInNode:self.cookiesLayer];
    
    NSInteger column, row;
    if ([self convertPoint:location toColumn:&column row:&row]) {
        // ensure there is a cookie at the column, row
        Cookie *cookie = [self.level cookieAtColumn:column row:row];
        if (cookie != nil) {
            [self showSelectionIndicatorForCookie:cookie];
            
            // record swiped column, row
            self.swipeFromColumn = column;
            self.swipeFromRow = row;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // swipe began outside of valid area || game already swapped cookie so ignore
    if (self.swipeFromColumn == NSNotFound) return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self.cookiesLayer];
    
    NSInteger column, row;
    if ([self convertPoint:location toColumn:&column row:&row]) {
        // figure out direction of swipe
        NSInteger horizontalDelta = 0, verticalDelta = 0;
        if (column < self.swipeFromColumn)      // left swipe
            horizontalDelta = -1;
        else if (column > self.swipeFromColumn) // right swipe
            horizontalDelta = 1;
        else if (row < self.swipeFromRow)       // down swipe
            verticalDelta = -1;
        else if (row > self.swipeFromRow)       // up swipe
            verticalDelta = 1;
        
        if (horizontalDelta != 0 || verticalDelta != 0) {
            // try swap
            [self trySwapHorizontal:horizontalDelta vertical:verticalDelta];
            
            [self hideSelectionIndicator];
            
            // reset swipeFromColumn
            self.swipeFromColumn = NSNotFound;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.selectionSprite.parent != nil && self.swipeFromColumn != NSNotFound)
        [self hideSelectionIndicator];
    
    self.swipeFromColumn = self.swipeFromRow = NSNotFound;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - Helper methods

// returns center
- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row {
    return CGPointMake(column * TileWidth + TileWidth/2, row * TileHeight + TileHeight/2);
}

// return: YES if point is within the grid and stores the corresponding column and row
- (BOOL)convertPoint:(CGPoint)point toColumn:(NSInteger *)column row:(NSInteger *)row {
    // ensure column and row pointers are non-nil
    NSParameterAssert(column);
    NSParameterAssert(row);
    
    if (point.x >= 0 && point.x < NumColumns * TileWidth &&
        point.y >= 0 && point.y < NumRows * TileHeight) {
        
        *column = point.x / TileWidth;
        *row = point.y / TileHeight;
        return YES;
    } else {
        *column = NSNotFound;
        *row = NSNotFound;
        return NO;
    }
}

- (void)trySwapHorizontal:(NSInteger)horizontalDelta vertical:(NSInteger)verticalDelta {
    // calculate column, row of cookie to swap with
    NSInteger toColumn = self.swipeFromColumn + horizontalDelta;
    NSInteger toRow = self.swipeFromRow + verticalDelta;
    
    // ensure toColumn, toRow is within the grid
    if (toColumn < 0 || toColumn >= NumColumns) return;
    if (toRow < 0 || toRow >= NumRows)  return;
    
    // ensure there is a cookie at toColumn, toRow
    Cookie *toCookie = [self.level cookieAtColumn:toColumn row:toRow];
    if (toCookie == nil)  return;
    
    Cookie *fromCookie = [self.level cookieAtColumn:self.swipeFromColumn row:self.swipeFromRow];
    
    // just log for now
    if (self.swipeHandler != nil) {
        NSLog(@"*** swapping %@ with %@", fromCookie, toCookie);
        Swap *swap = [[Swap alloc] init];
        swap.cookieA = fromCookie;
        swap.cookieB = toCookie;
        
        self.swipeHandler(swap);
    }
}

// animates the swap
// dispatch_block_t is shorthand for a block that returns void and takes no parameters
- (void)animateSwap:(Swap *)swap completion:(dispatch_block_t)completion {
    // move cookie you started with a bit higher
    swap.cookieA.sprite.zPosition = 100;
    swap.cookieB.sprite.zPosition = 90;
    
    const NSTimeInterval duration = 0.3;
    
    SKAction *moveA = [SKAction moveTo:swap.cookieB.sprite.position duration:duration];
    moveA.timingMode = SKActionTimingEaseOut;
    // after animation completes, completion handler is called
    [swap.cookieA.sprite runAction:[SKAction sequence:@[moveA, [SKAction runBlock:completion]]]];
    
    SKAction *moveB = [SKAction moveTo:swap.cookieA.sprite.position duration:duration];
    moveB.timingMode = SKActionTimingEaseOut;
    [swap.cookieB.sprite runAction:moveB];
}

- (void)animateInvalidSwap:(Swap *)swap completion:(dispatch_block_t)completion {
    swap.cookieA.sprite.zPosition = 100;
    swap.cookieB.sprite.zPosition = 90;
    
    const NSTimeInterval duration = 0.3;
    
    SKAction *moveA = [SKAction moveTo:swap.cookieB.sprite.position duration:duration];
    moveA.timingMode = SKActionTimingEaseOut;
    
    SKAction *moveB = [SKAction moveTo:swap.cookieA.sprite.position duration:duration];
    moveB.timingMode = SKActionTimingEaseOut;
    
    [swap.cookieA.sprite runAction:[SKAction sequence:@[moveA, moveB, [SKAction runBlock:completion]]]];
    [swap.cookieB.sprite runAction:[SKAction sequence:@[moveB, moveA]]];
}

- (void)animateMatchedCookies:(NSSet *)chains completion:(dispatch_block_t)completion {
    for (Chain *chain in chains) {
        for (Cookie *cookie in chain.cookies) {
            if (cookie.sprite != nil) { // same cookie can be part of two chains, but we only want to add one animation to the sprite
                SKAction *scaleAction = [SKAction scaleTo:0.1 duration:0.3];
                scaleAction.timingMode = SKActionTimingEaseOut;
                [cookie.sprite runAction:[SKAction sequence:@[scaleAction, [SKAction removeFromParent]]]];
                
                cookie.sprite = nil;    // this is for the comment in the above if
            }
        }
    }
    
    // play maych sound
    
    // wait for animation to complete before continuing
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.3],
                                         [SKAction runBlock:completion]]]];
}

- (void)animateFallingCookies:(NSArray *)columns completion:(dispatch_block_t)completion {
    // b/c the number of falling cookies varies, we have to compute the duration
    __block NSTimeInterval longestDuration = 0;
    
    for (NSArray *array in columns) {
        [array enumerateObjectsUsingBlock:^(Cookie *cookie, NSUInteger idx, BOOL *stop) {
            CGPoint newPosition = [self pointForColumn:cookie.column row:cookie.row];
            
            // the higher up the cookie, the bigger the delay on animation
            // this works out because fillHoles guarantees that lower cookies are first in
            NSTimeInterval delay = 0.05 + 0.15 * idx;
            
            // duration of animation is based on how far the cookie has to fall (0.1 sec/tile)
            NSTimeInterval duration = ((cookie.sprite.position.y - newPosition.y) / TileHeight) * 0.1;
            
            longestDuration = MAX(longestDuration, duration + delay);
            
            // perform animation
            SKAction *moveAction = [SKAction moveTo:newPosition duration:duration];
            moveAction.timingMode = SKActionTimingEaseOut;
            [cookie.sprite runAction:[SKAction sequence:@[[SKAction waitForDuration:delay], moveAction]]];
        }];
    }
    
    // wait until all cookies have fallen before continueing game
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:longestDuration],
                                         [SKAction runBlock:completion]]]];
}

- (void)showSelectionIndicatorForCookie:(Cookie *)cookie {
    // if selection indicator is visible, remove it
    if (self.selectionSprite.parent != nil)
        [self.selectionSprite removeFromParent];
    
    SKTexture *texture = [SKTexture textureWithImageNamed:[cookie highlightedSpriteName]];
    self.selectionSprite.size = texture.size;   // this doesn't set the correct size, have to use SKAction
    [self.selectionSprite runAction:[SKAction setTexture:texture]];
    
    [cookie.sprite addChild:self.selectionSprite];  // add as child so the selection sprite moves with cookie sprite
    self.selectionSprite.alpha = 1.0;   // makes it visible
}

- (void)hideSelectionIndicator {
    [self.selectionSprite runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:0.3],
                                                         [SKAction removeFromParent]]]];
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
