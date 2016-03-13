//
//  HealthBar.h
//  PuzzleQuest
//
//  Created by Ken Zheng on 3/13/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthBar : UIView

@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, assign) double percentage;    // 0-1
@property (nonatomic, copy) NSString *displayString;

@end
