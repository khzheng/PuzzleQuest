//
//  Chain.h
//  PuzzleQuest
//
//  Created by Ken Zheng on 6/25/15.
//  Copyright (c) 2015 Ken Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cookie;

typedef NS_ENUM(NSUInteger, ChainType) {
    ChainTypeHorizontal,
    ChainTypeVertical,
};

@interface Chain : NSObject

@property (strong, nonatomic, readonly) NSArray *cookies;
@property (nonatomic, assign) ChainType chainType;

- (void)addCookie:(Cookie *)cookie;
- (NSUInteger)count;

@end
