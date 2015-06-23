//
//  Level.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/22/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import "Level.h"

@implementation Level {
    Cookie *_cookies[NumColumns][NumRows];
}

- (NSSet *)shuffle {
    return [self createInitialCookies];
}

- (Cookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return _cookies[column][row];
}

#pragma mark - Helper methods

- (NSSet *)createInitialCookies {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            NSUInteger cookieType = arc4random_uniform(NumberCookieTypes) + 1;  // + 1 b/c we want 1-6
            
            Cookie *cookie = [[Cookie alloc] init];
            cookie.cookieType = cookieType;
            cookie.row = row;
            cookie.column = column;
            
            _cookies[row][column] = cookie;
            [set addObject:cookie];
        }
    }
    
    return set;
}

@end
