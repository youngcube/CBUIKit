//
//  UISlider.m
//  ting_macOS
//
//  Created by cube on 2017/1/16.
//  Copyright © 2017年 cube. All rights reserved.
//

#import "UISlider.h"

@implementation UISlider
- (float)value
{
    return self.floatValue;
}

- (void)setValue:(float)value
{
    self.floatValue = value;
}

- (float)maximumValue
{
    return self.maxValue;
}

- (void)setMaximumValue:(float)maximumValue
{
    self.maxValue = maximumValue;
}

- (float)minimumValue
{
    return self.minValue;
}

- (void)setMinimumValue:(float)minimumValue
{
    self.minValue = minimumValue;
}

@end
