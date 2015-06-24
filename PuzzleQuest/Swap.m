//
//  Swap.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/23/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import "Swap.h"

@implementation Swap

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ swap %@ with %@", [super description], self.cookieA, self.cookieB];
}

@end
