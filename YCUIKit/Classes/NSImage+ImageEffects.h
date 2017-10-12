//
//  NSImage+ImageEffects.h
//  ting_macOS
//
//  Created by cube on 2017/1/9.
//  Copyright © 2017年 cube. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#ifndef _TING_
//CGContextRef UIGraphicsGetCurrentContext(void);
#endif
BOOL XUIAliasMethod(Class cls, char plusOrMinus, SEL originalSel, SEL aliasSel);
BOOL XUISwizzleMethod(Class cls, char plusOrMinus, SEL originalSel, SEL replacementSel);

@interface NSValue (XUIKitAdditions)
@property(readonly) CGPoint CGPointValue;
+ (NSValue *)valueWithCGPoint:(CGPoint)point;
@end
typedef NS_OPTIONS(NSUInteger, XUIRectCorner) {
    XUIRectCornerTopLeft     = 1 << 0,
    XUIRectCornerTopRight    = 1 << 1,
    XUIRectCornerBottomLeft  = 1 << 2,
    XUIRectCornerBottomRight = 1 << 3,
    XUIRectCornerAllCorners  = ~0
};

typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
    UIRectCornerTopLeft     = 1 << 0,
    UIRectCornerTopRight    = 1 << 1,
    UIRectCornerBottomLeft  = 1 << 2,
    UIRectCornerBottomRight = 1 << 3,
    UIRectCornerAllCorners  = ~0UL
};
@interface NSBezierPath (XUIKitAdditions)

+ (NSBezierPath *) bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
+ (NSBezierPath *) bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(XUIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
+ (NSBezierPath *) bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;
+ (NSBezierPath *) bezierPathWithCGPath:(CGPathRef)CGPath;

- (void) addLineToPoint:(CGPoint)point;
- (void) addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2;
- (void) addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint;
- (void) addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

- (void) appendPath:(NSBezierPath *)bezierPath;
- (void) applyTransform:(CGAffineTransform)transform;

- (void) fillWithBlendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void) strokeWithBlendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

@property (nonatomic) CGPathRef CGPath;
- (CGPathRef) CGPath NS_RETURNS_INNER_POINTER;

@property (nonatomic) BOOL usesEvenOddFillRule; // Default is NO. When YES, the even-odd fill rule is used for drawing, clipping, and hit testing.

@end

@interface NSImage (ImageEffects)
- (NSImage *)imageWithRoundedCornersSize:(float)cornerRadius;
- (NSImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;
- (NSImage *)imageCompressedByFactor:(float)factor;
+ (NSImage *)imageWithColor:(NSColor *)color;
- (NSImage *)scaleImageInRect:(CGRect)rect;
- (NSImage *)imageWithRoundedCorners:(UIRectCorner)corners cornerRadius:(float)cornerRadius;
@end
