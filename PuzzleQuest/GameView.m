//
//  GameView.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 5/7/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "GameView.h"

@interface GameView()
@end

@implementation GameView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    }
    
    return self;
}

@end
