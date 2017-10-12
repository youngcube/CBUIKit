//
//  UICollectionView.m
//  ting_macOS
//
//  Created by cube on 22/05/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import "UICollectionView.h"
#import "UIView.h"

@implementation UICollectionReusableView

- (void)setNeedsLayout
{
    self.needsLayout = YES;
}

- (CALayer *)layer
{
    self.wantsLayer = YES;
    return [super layer];
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

- (void)setAlpha:(CGFloat)alpha
{
    _alpha = alpha;
    self.alphaValue = alpha;
}

#pragma mark 重写width
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width
{
    return self.frame.size.width;
}

#pragma mark 重写height
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height
{
    return self.frame.size.height;
}

@end

@implementation UICollectionViewFlowLayout

@end

@implementation UICollectionViewLayout

@end

@implementation UICollectionViewLayoutAttributes

+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath
{
    return [self layoutAttributesForItemWithIndexPath:indexPath];
}

@end

@implementation UICollectionViewCell
- (UIView *)contentView
{
    return (UIView *)self.view;
}

- (CALayer *)layer
{
    self.view.wantsLayer = YES;
    return self.view.layer;
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

- (void)setNeedsLayout
{
    self.view.needsLayout = YES;
}

- (void)layoutIfNeeded
{
    self.view.needsLayout = YES;
}

- (CGRect)bounds
{
    return self.view.bounds;
}

- (void)setBounds:(CGRect)bounds
{
    self.view.bounds = bounds;
}

- (void)setFrame:(CGRect)frame
{
    self.view.frame = frame;
}

- (CGRect)frame
{
    return self.view.frame;
}
#pragma mark 重写x
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x
{
    return self.frame.origin.x;
}

#pragma mark 重写y
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}

#pragma mark 重写width
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width
{
    return self.frame.size.width;
}

#pragma mark 重写height
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height
{
    return self.frame.size.height;
}

#pragma mark 重写size
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

#pragma mark 重写point
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin
{
    return self.frame.origin;
}

@end

@implementation UICollectionView
- (void)setNeedsLayout
{
    self.needsLayout = YES;
}

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self makeItemWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

- (__kindof UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *cell = [self makeSupplementaryViewOfKind:elementKind withIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (UICollectionViewCell *)[self itemAtIndexPath:indexPath];
}

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self registerClass:cellClass forItemWithIdentifier:identifier];
}

- (void)selectItemAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition
{
    NSSet *indexPaths = [NSSet setWithObject:indexPath];
    [self selectItemsAtIndexPaths:indexPaths scrollPosition:[self getNSScrollStyle:scrollPosition]];
}

- (NSCollectionViewScrollPosition)getNSScrollStyle:(UICollectionViewScrollPosition)style
{
    switch (style) {
        case UICollectionViewScrollPositionNone:
            return NSCollectionViewScrollPositionNone;
            break;
        case UICollectionViewScrollPositionTop:
            return NSCollectionViewScrollPositionTop;
            break;
        case UICollectionViewScrollPositionCenteredVertically:
            return NSCollectionViewScrollPositionCenteredVertically;
            break;
        case UICollectionViewScrollPositionBottom:
            return NSCollectionViewScrollPositionBottom;
            break;
        case UICollectionViewScrollPositionLeft:
            return NSCollectionViewScrollPositionLeft;
            break;
        case UICollectionViewScrollPositionCenteredHorizontally:
            return NSCollectionViewScrollPositionCenteredHorizontally;
            break;
        case UICollectionViewScrollPositionRight:
            return NSCollectionViewScrollPositionRight;
            break;
        default:
            return NSCollectionViewScrollPositionNone;
            break;
    }
}


@end

@implementation UICollectionViewController

@end

