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
@property (nonatomic, strong) HealthBar *hpBar;
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
        
        _hpBar = [[HealthBar alloc] initWithFrame:CGRectMake(0, 0, 54, 76)];
        _hpBar.barColor = [UIColor redColor];
        [self addSubview:_hpBar];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect bounds = [self bounds];
    
    self.skView.frame = bounds;
    
    CGSize hpLabelSize = self.hpLabel.frame.size;
    CGRect hpLabelRect = CGRectMake(bounds.size.width/2.0 - hpLabelSize.width/2.0, 50, hpLabelSize.width, hpLabelSize.height);
    self.hpLabel.frame = hpLabelRect;
    
    CGSize hpBarSize = self.hpBar.frame.size;
    CGRect hpBarRect = CGRectMake(bounds.size.width - hpBarSize.width, bounds.size.height - hpBarSize.height, hpBarSize.width, hpBarSize.height);
    self.hpBar.frame = hpBarRect;
}

@end
