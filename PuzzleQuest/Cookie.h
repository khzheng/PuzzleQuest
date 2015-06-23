//
//  Cookie.h
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/22/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@import SpriteKit;

static const NSUInteger NumberCookieTypes = 6;

@interface Cookie : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSUInteger cookieType;
@property (strong, nonatomic) SKSpriteNode *sprite;

- (NSString *)spriteName;
- (NSString *)highlightedSpriteName;

@end
