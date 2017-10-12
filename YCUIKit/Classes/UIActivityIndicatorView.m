//
//  UIActivityIndicatorView.m
//  ting_macOS
//
//  Created by cube on 2017/1/16.
//  Copyright © 2017年 cube. All rights reserved.
//

#import "UIActivityIndicatorView.h"

@implementation UIActivityIndicatorView

- (instancetype)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    if (self = [super init]){
        
    }
    return self;
}

- (void)startAnimating
{
    [self startAnimation:nil];
}

- (void)stopAnimating
{
    [self stopAnimation:nil];
}

@end
