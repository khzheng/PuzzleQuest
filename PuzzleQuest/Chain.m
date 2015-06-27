//
//  Chain.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/25/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import "Chain.h"

@implementation Chain {
    NSMutableArray *_cookies;
}

- (void)addCookie:(Cookie *)cookie {
    if (_cookies == nil)
        _cookies = [NSMutableArray array];
    [_cookies addObject:cookie];
}

- (NSArray *)cookies {
    return _cookies;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"type:%ld cookies:%@", (long)self.chainType, self.cookies];
}

@end
