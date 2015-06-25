//
//  Swap.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/23/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import "Swap.h"
#import "Cookie.h"

@implementation Swap

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ swap %@ with %@", [super description], self.cookieA, self.cookieB];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Swap class]])   return NO;
    
    // two swaps are equal if they contain the same cookie
    // doesn't matter if whether they're called A or B
    Swap *otherSwap = (Swap *)object;
    
    return ([self cookieA] == [otherSwap cookieA] && [self cookieB] == [otherSwap cookieB]) ||
           ([self cookieB] == [otherSwap cookieA] && [self cookieA] == [otherSwap cookieB]);
}

- (NSUInteger)hash {
    return [[self cookieA] hash] ^ [[self cookieB] hash];
}

@end
