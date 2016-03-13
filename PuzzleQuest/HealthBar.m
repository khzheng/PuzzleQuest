//
//  HealthBar.m
//  PuzzleQuest
//
//  Created by Ken Zheng on 3/13/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import "HealthBar.h"

@interface HealthBar()
@property (nonatomic, strong) UILabel *label;
@end

@implementation HealthBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _percentage = 1.0;
        
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:10.0];
        [self addSubview:_label];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect bounds = [self bounds];
    
    [UIColor blackColor];
    UIRectFill(bounds);
    
    CGRect healthRect = CGRectMake(0, bounds.size.height - bounds.size.height * self.percentage, bounds.size.width, bounds.size.height * self.percentage);
    [self.barColor set];
    UIRectFill(healthRect);
    
    CGSize labelSize = self.label.frame.size;
    CGRect labelRect = CGRectMake(bounds.size.width/2.0 - labelSize.width/2.0, bounds.size.height/2.0 - labelSize.height/2.0, labelSize.width, labelSize.height);
    self.label.frame = labelRect;
}

- (void)setBarColor:(UIColor *)barColor {
    _barColor = barColor;
    
    [self setNeedsDisplay];
}

- (void)setPercentage:(double)percentage {
    if (percentage > 1.0)
        percentage = 1.0;
    
    if (percentage < 0)
        percentage = 0;
    
    if (_percentage == percentage)
        return;
    
    _percentage = percentage;
    
    [self setNeedsDisplay];
}

- (void)setDisplayString:(NSString *)displayString {
    if (displayString == nil)
        displayString = @"";
    
    if ([_displayString isEqualToString:displayString])
        return;
    
    _displayString = [displayString copy];
    
    self.label.text = _displayString;
    [self.label sizeToFit];
    
    [self setNeedsDisplay];
}

@end
