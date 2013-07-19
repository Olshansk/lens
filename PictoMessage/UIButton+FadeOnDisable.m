//
//  UIButton+FadeOnDisable.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-07-18.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "UIButton+FadeOnDisable.h"

@implementation UIButton (FadeOnDisable)

- (void)setTitleAlpha:(CGFloat)alpha forState:(UIControlState)state
{
    UIColor *faded = [[self titleColorForState:UIControlStateNormal] colorWithAlphaComponent:alpha];
    [self setTitleColor:faded forState:state];
}

@end
