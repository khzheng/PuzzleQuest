//
//  BattleView.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 5/7/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "BattleView.h"

@interface BattleView()
@property (nonatomic, strong) SKView *skView;
@end

@implementation BattleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        _skView = [[SKView alloc] initWithFrame:frame];
        [self addSubview:_skView];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    
    self.skView.frame = bounds;
}

@end
