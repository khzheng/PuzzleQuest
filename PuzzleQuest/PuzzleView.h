//
//  GameView.h
//  PuzzleQuest
//
//  Created by Ken Zheng on 3/13/16.
//  Copyright © 2016 Ken Zheng. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HealthBar.h"

@interface PuzzleView : UIView

@property (nonatomic, readonly) SKView *skView;
@property (nonatomic, readonly) HealthBar *hpBar;
@property (nonatomic, readonly) UIButton *shuffleButton;

@end
