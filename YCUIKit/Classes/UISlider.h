//
//  UISlider.h
//  ting_macOS
//
//  Created by cube on 2017/1/16.
//  Copyright © 2017年 cube. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UISlider : NSSlider
@property(nonatomic) float value;                                 // default 0.0. this value will be pinned to min/max
@property(nonatomic) float minimumValue;                          // default 0.0. the current value may change if outside new min value
@property(nonatomic) float maximumValue;                          // default 1.0. the current value may change if outside new max value
@property(nonatomic) float progress;
@end
