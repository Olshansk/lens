//
//  UIView+EasyDimensions.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-18.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "UIView+EasyDimensions.h"

@implementation UIView (EasyDimensions)

- (NSInteger) topLeftX {
    return self.frame.origin.x;
}

- (NSInteger) topLeftY {
    return self.frame.origin.y;
}

- (NSInteger) topRightX {
    return self.frame.origin.x + self.frame.size.width;
}

- (NSInteger) topRightY {
    return self.frame.origin.y;
}

- (NSInteger) bottomLeftX {
    return self.frame.origin.x;
}

- (NSInteger) bottomLeftY {
    return self.frame.origin.y + self.frame.size.height;
}

- (NSInteger) bottomRightX {
    return self.frame.origin.x + self.frame.size.width;
}

- (NSInteger) bottomRightY {
    return self.frame.origin.y + self.frame.size.height;
}

@end
