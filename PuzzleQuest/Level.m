//
//  Level.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/22/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import "Level.h"
#import "Cookie.h"
#import "Tile.h"

@implementation Level {
    Cookie *_cookies[NumColumns][NumRows];  // keeps track of Cookie objects
    Tile *_tiles[NumColumns][NumRows];      // keeps track of which tiles are empty or contain a Cookie
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // create tiles
        for (NSInteger row = 0; row < NumRows; row++)
            for (NSInteger column = 0; column < NumColumns; column++)
                _tiles[column][row] = [[Tile alloc] init];
    }
    
    return self;
}

- (NSSet *)shuffle {
    return [self createInitialCookies];
}

- (Cookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return _cookies[column][row];
}

- (Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return _tiles[column][row];
}

#pragma mark - Helper methods

- (NSSet *)createInitialCookies {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            if (_tiles[column][row] != nil) {   // make sure a tile is there
                NSUInteger cookieType = arc4random_uniform(NumberCookieTypes) + 1;  // + 1 b/c we want 1-6
                
                Cookie *cookie = [[Cookie alloc] init];
                cookie.cookieType = cookieType;
                cookie.row = row;
                cookie.column = column;
                
                _cookies[row][column] = cookie;
                [set addObject:cookie];
            }
        }
    }
    
    return set;
}

@end