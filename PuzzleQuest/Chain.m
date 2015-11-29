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

- (NSUInteger)count {
    return [_cookies count];
}

- (BOOL)intersectsChain:(Chain *)chain {
    return [self intersectingCookie:chain] == nil ? NO : YES;
}

- (Cookie *)intersectingCookie:(Chain *)chain {
    NSMutableSet *intersectingCookies = [NSMutableSet setWithArray:self.cookies];
    [intersectingCookies intersectSet:[NSSet setWithArray:chain.cookies]];
    
    return [intersectingCookies count] > 0 ? [intersectingCookies anyObject] : nil;
}

- (BOOL)containsCookie:(Cookie *)cookie {
    return [self.cookies containsObject:cookie];
}

- (NSArray *)cookies {
    return _cookies;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"type:%ld cookies:%@", (long)self.chainType, self.cookies];
}

@end
