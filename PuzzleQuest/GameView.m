//
//  GameView.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 3/13/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "GameView.h"

@interface GameView()
@property (nonatomic, strong) SKView *skView;
@property (nonatomic, strong) UILabel *hpLabel;
@property (nonatomic, strong) UILabel *movesLabel;
@property (nonatomic, strong) UILabel *enemyLabel;
@end

@implementation GameView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _skView = [[SKView alloc] initWithFrame:frame];
        [self addSubview:_skView];
        
        _hpLabel = [[UILabel alloc] init];
        _hpLabel.textColor = [UIColor blackColor];
        _hpLabel.text = @"HP:";
        [_hpLabel sizeToFit];
        [self addSubview:_hpLabel];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect bounds = [self bounds];
    NSLog(@"bounds: %@", NSStringFromCGRect(bounds));
    
    self.skView.frame = bounds;
    
    CGSize hpLabelSize = self.hpLabel.frame.size;
    CGRect hpLabelRect = CGRectMake(bounds.size.width/2.0 - hpLabelSize.width/2.0, 50, hpLabelSize.width, hpLabelSize.height);
    self.hpLabel.frame = hpLabelRect;
}

@end
