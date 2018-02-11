//
//  UIView.h
//  ting_macOS
//
//  Created by cube on 2017/1/9.
//  Copyright © 2017年 cube. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef NS_OPTIONS(NSUInteger, UIViewAutoresizing) {
    UIViewAutoresizingNone                 = 0,
    UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
    UIViewAutoresizingFlexibleWidth        = 1 << 1,
    UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
    UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
    UIViewAutoresizingFlexibleHeight       = 1 << 4,
    UIViewAutoresizingFlexibleBottomMargin = 1 << 5
};

#pragma mark - UIView Like
@class UIView;
@protocol UIViewDelegate <NSObject>
- (void)uiview:(UIView *_Nonnull)view viewDidHidden:(BOOL)hidden;
- (void)uiviewDidLayout:(UIView *_Nonnull)view;
@end

@interface NSScreen (YCUIKit)
- (CGFloat)scale;
+ (CGFloat)scale;
@end

@interface NSValue (YCUIKit)
+ (NSValue *)valueWithCGRect:(CGRect)rect;
- (CGRect)CGRectValue;
@end

@interface UIView : NSView
NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSUInteger, UIViewAnimationOptions) {
    UIViewAnimationOptionLayoutSubviews            = 1 <<  0,
    UIViewAnimationOptionAllowUserInteraction      = 1 <<  1, // turn on user interaction while animating
    UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2, // start all views from current value, not initial value
    UIViewAnimationOptionRepeat                    = 1 <<  3, // repeat animation indefinitely
    UIViewAnimationOptionAutoreverse               = 1 <<  4, // if repeat, run animation back and forth
    UIViewAnimationOptionOverrideInheritedDuration = 1 <<  5, // ignore nested duration
    UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
    UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
    UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
    UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
    
    UIViewAnimationOptionCurveEaseInOut            = 0 << 16, // default
    UIViewAnimationOptionCurveEaseIn               = 1 << 16,
    UIViewAnimationOptionCurveEaseOut              = 2 << 16,
    UIViewAnimationOptionCurveLinear               = 3 << 16,
    
    UIViewAnimationOptionTransitionNone            = 0 << 20, // default
    UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
    UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
    UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
    UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
    UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
    UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
    UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
};

typedef NS_OPTIONS(NSUInteger, UIViewKeyframeAnimationOptions) {
    UIViewKeyframeAnimationOptionLayoutSubviews            = UIViewAnimationOptionLayoutSubviews,
    UIViewKeyframeAnimationOptionAllowUserInteraction      = UIViewAnimationOptionAllowUserInteraction, // turn on user interaction while animating
    UIViewKeyframeAnimationOptionBeginFromCurrentState     = UIViewAnimationOptionBeginFromCurrentState, // start all views from current value, not initial value
    UIViewKeyframeAnimationOptionRepeat                    = UIViewAnimationOptionRepeat, // repeat animation indefinitely
    UIViewKeyframeAnimationOptionAutoreverse               = UIViewAnimationOptionAutoreverse, // if repeat, run animation back and forth
    UIViewKeyframeAnimationOptionOverrideInheritedDuration = UIViewAnimationOptionOverrideInheritedDuration, // ignore nested duration
    UIViewKeyframeAnimationOptionOverrideInheritedOptions  = UIViewAnimationOptionOverrideInheritedOptions, // do not inherit any options or animation type
    
    UIViewKeyframeAnimationOptionCalculationModeLinear     = 0 << 10, // default
    UIViewKeyframeAnimationOptionCalculationModeDiscrete   = 1 << 10,
    UIViewKeyframeAnimationOptionCalculationModePaced      = 2 << 10,
    UIViewKeyframeAnimationOptionCalculationModeCubic      = 3 << 10,
    UIViewKeyframeAnimationOptionCalculationModeCubicPaced = 4 << 10
};

typedef NSBezierPath UIBezierPath;

typedef NS_OPTIONS(NSUInteger, UIControlEvents) {
    UIControlEventTouchDown                                         = 1 <<  0,      // on all touch downs
    UIControlEventTouchDownRepeat                                   = 1 <<  1,      // on multiple touchdowns (tap count > 1)
    UIControlEventTouchDragInside                                   = 1 <<  2,
    UIControlEventTouchDragOutside                                  = 1 <<  3,
    UIControlEventTouchDragEnter                                    = 1 <<  4,
    UIControlEventTouchDragExit                                     = 1 <<  5,
    UIControlEventTouchUpInside                                     = 1 <<  6,
    UIControlEventTouchUpOutside                                    = 1 <<  7,
    UIControlEventTouchCancel                                       = 1 <<  8,
    
    UIControlEventValueChanged                                      = 1 << 12,     // sliders, etc.
    UIControlEventPrimaryActionTriggered NS_ENUM_AVAILABLE_IOS(9_0) = 1 << 13,     // semantic action: for buttons, etc.
    
    UIControlEventEditingDidBegin                                   = 1 << 16,     // UITextField
    UIControlEventEditingChanged                                    = 1 << 17,
    UIControlEventEditingDidEnd                                     = 1 << 18,
    UIControlEventEditingDidEndOnExit                               = 1 << 19,     // 'return key' ending editing
    
    UIControlEventAllTouchEvents                                    = 0x00000FFF,  // for touch events
    UIControlEventAllEditingEvents                                  = 0x000F0000,  // for UITextField
    UIControlEventApplicationReserved                               = 0x0F000000,  // range available for application use
    UIControlEventSystemReserved                                    = 0xF0000000,  // range reserved for internal framework use
    UIControlEventAllEvents                                         = 0xFFFFFFFF
};

typedef NS_ENUM(NSInteger, UILayoutConstraintAxis) {
    UILayoutConstraintAxisHorizontal = 0,
    UILayoutConstraintAxisVertical = 1
};

typedef float UILayoutPriority NS_TYPED_EXTENSIBLE_ENUM;

+ (void)transitionWithView:(__kindof NSView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^ __nullable)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;

@property (nonatomic, weak) id <UIViewDelegate> viewDelegate;
- (void)bringSubviewToFront:(NSView *)view;
+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations;
+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;
+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;
+ (void)animateKeyframesWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewKeyframeAnimationOptions)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;
- (void)layoutSubviews;
- (void)setNeedsDisplay;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)setContentCompressionResistancePriority:(UILayoutPriority)priority forAxis:(UILayoutConstraintAxis)axis;
@end

@interface UIGestureRecognizer : NSGestureRecognizer

@end

@interface UITapGestureRecognizer : UIGestureRecognizer

@end

@interface NSView (UIKitExtension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, copy) NSColor *backgroundColor;
@property (nonatomic, assign) CGFloat alpha;
@end

NS_ASSUME_NONNULL_END
