//
//  GameView.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 3/13/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "PuzzleView.h"

@interface PuzzleView()
@property (nonatomic, strong) SKView *skView;
@property (nonatomic, strong) UILabel *hpLabel;
@property (nonatomic, strong) UILabel *movesLabel;
@property (nonatomic, strong) UILabel *enemyLabel;
@property (nonatomic, strong) HealthBar *hpBar;
@property (nonatomic, strong) UIButton *shuffleButton;
@end

@implementation PuzzleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        _skView = [[SKView alloc] initWithFrame:frame];
        [self addSubview:_skView];
        
        _hpLabel = [[UILabel alloc] init];
        _hpLabel.textColor = [UIColor blackColor];
        _hpLabel.text = @"HP:";
        [_hpLabel sizeToFit];
//        [self addSubview:_hpLabel];
        
        _hpBar = [[HealthBar alloc] initWithFrame:CGRectMake(0, 0, 54, 76)];
        _hpBar.barColor = [UIColor redColor];
//        [self addSubview:_hpBar];
        
        _shuffleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_shuffleButton setTitle:@"Shuffle" forState:UIControlStateNormal];
        [_shuffleButton sizeToFit];
//        [self addSubview:_shuffleButton];
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
    CGRect hpBarRect = CGRectMake(bounds.size.width - hpBarSize.width,
                                  0,
                                  hpBarSize.width,
                                  hpBarSize.height);
    self.hpBar.frame = hpBarRect;
    
    CGSize shuffleButtonSize = self.shuffleButton.frame.size;
    CGRect shuffleButtonRect = CGRectMake(bounds.size.width/2.0 - shuffleButtonSize.width/2.0,
                                          20,
                                          shuffleButtonSize.width,
                                          shuffleButtonSize.height);
    self.shuffleButton.frame = shuffleButtonRect;
}

@end
