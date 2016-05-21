//
//  UIView+IBInspectables.h
//  KMCore
//
//  Created by Keith Moon on 06/12/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

@import UIKit;

@interface UIView (IBInspectables)

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@end
