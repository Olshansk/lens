//
//  UIButton+FadeOnDisable.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-07-18.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FadeOnDisable)

- (void)setTitleAlpha:(CGFloat)alpha forState:(UIControlState)state;

@end
