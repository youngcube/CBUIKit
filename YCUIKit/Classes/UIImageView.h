//
//  UIImageView.h
//  ting_macOS
//
//  Created by cube on 2017/1/9.
//  Copyright © 2017年 cube. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef NS_ENUM(NSInteger, UIViewContentMode) {
    UIViewContentModeScaleToFill,
    UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
    UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
    UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
    UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
    UIViewContentModeTop,
    UIViewContentModeBottom,
    UIViewContentModeLeft,
    UIViewContentModeRight,
    UIViewContentModeTopLeft,
    UIViewContentModeTopRight,
    UIViewContentModeBottomLeft,
    UIViewContentModeBottomRight,
};
typedef NSImage UIImage;
@interface UIImageView : NSImageView
@property(nonatomic, strong) NSArray <UIImage *> *animationImages;
@property(nonatomic) NSTimeInterval animationDuration;
@property (nonatomic) CGFloat alpha;
@property (nonatomic) UIViewContentMode contentMode;
@property (nonatomic, copy) NSColor *backgroundColor;
- (instancetype)initWithImage:(UIImage *)image;
- (void)startAnimating;
- (void)stopAnimating;
@end
