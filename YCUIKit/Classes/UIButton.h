//
//  UIButton.h
//  ting_macOS
//
//  Created by cube on 2017/1/9.
//  Copyright © 2017年 cube. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UIView.h"
#import "UILabel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, UIControlState) {
    UIControlStateNormal,
    UIControlStateHighlighted,
    UIControlStateDisabled,
    UIControlStateSelected,
    UIControlStateFocused,
    UIControlStateApplication,
    UIControlStateReserved
};

typedef NS_ENUM(NSInteger, UIButtonType) {
    UIButtonTypeCustom = 0,                         // no button type
    UIButtonTypeSystem,  // standard system button
    
    UIButtonTypeDetailDisclosure,
    UIButtonTypeInfoLight,
    UIButtonTypeInfoDark,
    UIButtonTypeContactAdd,
    
    UIButtonTypeRoundedRect = UIButtonTypeSystem,   // Deprecated, use UIButtonTypeSystem instead
};

@interface UIButton : NSButton
@property (nonatomic) CGAffineTransform transform;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSColor *backgroundColor;
@property (nonatomic) BOOL adjustsImageWhenDisabled;
@property (nonatomic) BOOL adjustsImageWhenHighlighted;
@property (nonatomic) NSEdgeInsets imageEdgeInsets;
- (void)layoutSubviews;
- (void)setImage:(nullable NSImage *)image forState:(UIControlState)state;
- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state;
- (void)setButtonTitle:(NSString *)title;
- (void)setImage:(NSString *)image highlightedImage:(NSString *)highImage;
- (void)setBackgroundImage:(NSString *)image highlightedImage:(NSString *)highImage;
- (void)setBackgroundImage:(nullable NSImage *)image forState:(UIControlState)state;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)setTitleColor:(nullable NSColor *)color forState:(UIControlState)state;
+ (instancetype)buttonWithType:(UIButtonType)buttonType;
@property (nonatomic, strong) NSImage *backgroundImage;
@end
NS_ASSUME_NONNULL_END
