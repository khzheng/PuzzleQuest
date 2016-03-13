//
//  Chain.h
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/25/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cookie.h"

typedef NS_ENUM(NSUInteger, ChainType) {
    ChainTypeHorizontal,
    ChainTypeVertical,
    ChainTypeL,
    ChainTypeT,
    ChainTypeCross,
    ChainTypeUnknown,
};

@interface Chain : NSObject

@property (strong, nonatomic, readonly) NSArray *cookies;
@property (nonatomic, assign) ChainType chainType;
@property (nonatomic, assign) NSUInteger score;

- (void)addCookie:(Cookie *)cookie;
- (NSUInteger)count;
- (BOOL)intersectsChain:(Chain *)chain;
- (Cookie *)intersectingCookie:(Chain *)chain;
- (BOOL)containsCookie:(Cookie *)cookie;
- (CookieType)cookieType;

@end
