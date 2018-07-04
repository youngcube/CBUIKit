//
//  UIButton.m
//  ting_macOS
//
//  Created by cube on 2017/1/9.
//  Copyright © 2017年 cube. All rights reserved.
//

#import "UIButton.h"

@interface UIButton ()
@property (nonatomic, strong) NSImage *originalImage;
@property (nonatomic, strong) NSImage *selectedImage;
@property (nonatomic, copy) NSString *originalTitle;
@property (nonatomic, copy) NSString *selectedTitle;
@end

@implementation UIButton

#pragma mark - Init Method
- (instancetype)init
{
    self = [super init];
    if (self){
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self){
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self){
        [self commonInit];
    }
    return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    UIButton *button = [[UIButton alloc] init];
    return button;
}

- (void)commonInit
{
    [self setButtonType:7]; //NSButtonTypeMomentaryPushIn
    [self setWantsLayer:YES];
    self.layer.anchorPoint = NSMakePoint(0.5, 0.5);
}

- (void)layoutSubviews
{
    [self layoutSubtreeIfNeeded];
}

- (NSColor *)backgroundColor
{
    if (self.layer.backgroundColor){
        return [NSColor colorWithCGColor:self.layer.backgroundColor];
    }
    return nil;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    self.layer.backgroundColor = backgroundColor.CGColor;
}

#pragma mark - Public Method
- (CALayer *)layer
{
    if (!self.wantsLayer){
        [self setWantsLayer:YES];
    }
    return [super layer];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if (state == UIControlStateNormal){
        self.originalTitle = title;
        self.title = title;
    }else if (state == UIControlStateSelected){
        self.selectedTitle = title;
    }
}

- (void)setImage:(NSImage *)image forState:(UIControlState)state
{
    if (state == UIControlStateNormal){
        self.originalImage = image;
        self.image = image;
    }else if (state == UIControlStateSelected){
        self.selectedImage = image;
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected){
        self.image = self.selectedImage;
        self.title = self.selectedTitle;
    }else{
        self.image = self.originalImage;
        self.title = self.originalTitle;
    }
    [self setNeedsDisplay:YES];
}

- (void)setButtonTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateDisabled];
}

- (void)setImage:(NSString *)image highlightedImage:(NSString *)highImage
{
    [self setImage:[NSImage imageNamed:image]];
}

- (void)setBackgroundImage:(NSString *)image highlightedImage:(NSString *) highImage
{
//    [self setImage:[NSImage imageNamed:image]];
}

- (void)setBackgroundImage:(nullable NSImage *)image forState:(UIControlState)state
{
    [self setImage:image forState:state];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if (target){
        [self setTarget:target];
    }
    if (action){
        [self setAction:action];
    }
}

- (void)setTitleColor:(nullable NSColor *)color forState:(UIControlState)state
{
    
}

@end
