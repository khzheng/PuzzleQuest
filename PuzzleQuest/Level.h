//
//  Level.h
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/22/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cookie;
@class Tile;
@class Swap;

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface Level : NSObject

- (NSSet *)shuffle;
- (Cookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row;
- (Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
- (void)performSwap:(Swap *)swap;

@end
