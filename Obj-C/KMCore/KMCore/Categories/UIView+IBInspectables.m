//
//  UIView+IBInspectables.m
//  KMCore
//
//  Created by Keith Moon on 06/12/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import "UIView+IBInspectables.h"

@implementation UIView (IBInspectables)

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

@end
