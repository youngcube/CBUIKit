//
//  UILabel.m
//  ting_macOS
//
//  Created by cube on 2017/1/9.
//  Copyright © 2017年 cube. All rights reserved.
//

#import "UILabel.h"

@implementation UILabel

- (instancetype)init
{
    self = [super init];
    if (self){
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self){
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self){
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.editable = NO;
    self.bordered = NO;
    self.backgroundColor = [NSColor clearColor];
}

- (NSTextAlignment)textAlignment
{
    return self.alignment;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [self setAlignment:textAlignment];
}

- (void)setText:(NSString *)text
{
    if (text){
        self.stringValue = text;
    }
}

- (NSString *)text
{
    return self.stringValue;
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [self setAttributedStringValue:attributedText];
}

- (NSAttributedString *)attributedText
{
    return self.attributedStringValue;
}

@end


@implementation UITextField

- (void)setText:(NSString *)text
{
    if (text){
        self.stringValue = text;
    }
}

- (NSString *)text
{
    return self.stringValue;
}

@end

@interface EUCenterLabelCell : NSTextFieldCell

@end

@implementation EUCenterLabelCell
- (NSRect) titleRectForBounds:(NSRect)frame
{
    CGFloat stringHeight = self.attributedStringValue.size.height;
    NSRect titleRect = [super titleRectForBounds:frame];
    titleRect.origin.y = frame.origin.y + (frame.size.height - stringHeight) / 2.0;
    return titleRect;
}

- (void) drawInteriorWithFrame:(NSRect)cFrame inView:(NSView*)cView
{
    [super drawInteriorWithFrame:[self titleRectForBounds:cFrame] inView:cView];
}
@end

@implementation EUCenterLabel
+ (void)load
{
    [self setCellClass:[EUCenterLabelCell class]];
}

@end
