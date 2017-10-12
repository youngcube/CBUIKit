//
//  UIImageView.m
//  ting_macOS
//
//  Created by cube on 2017/1/9.
//  Copyright © 2017年 cube. All rights reserved.
//

#import "UIImageView.h"

@implementation UIImageView

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self){
        [self setImage:image];
    }
    return self;
}

- (void)setAlpha:(CGFloat)alpha
{
    _alpha = alpha;
    self.alphaValue = alpha;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.wantsLayer = YES;
    self.layer.backgroundColor = backgroundColor.CGColor;
}

- (void)startAnimating
{
    
}

- (void)stopAnimating
{
    
}
@end
