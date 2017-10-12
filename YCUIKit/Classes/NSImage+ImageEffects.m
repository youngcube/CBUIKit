//
//  NSImage+ImageEffects.m
//  ting_macOS
//
//  Created by cube on 2017/1/9.
//  Copyright © 2017年 cube. All rights reserved.
//

#import "NSImage+ImageEffects.h"
#import <objc/objc-runtime.h>

#ifndef _TING_
CGContextRef UIGraphicsGetCurrentContext(void)
{
    return (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
}
#endif

BOOL XUISwizzleMethod(Class cls, char plusOrMinus, SEL selA, SEL selB)
{
    if (plusOrMinus == '+') {
        const char *clsName = class_getName(cls);
        cls = objc_getMetaClass(clsName);
    }
    
    Method methodA = class_getInstanceMethod(cls, selA);
    if (!methodA) return NO;
    
    Method methodB = class_getInstanceMethod(cls, selB);
    if (!methodB) return NO;
    
    class_addMethod(cls, selA, class_getMethodImplementation(cls, selA), method_getTypeEncoding(methodA));
    class_addMethod(cls, selB, class_getMethodImplementation(cls, selB), method_getTypeEncoding(methodB));
    
    method_exchangeImplementations(class_getInstanceMethod(cls, selA), class_getInstanceMethod(cls, selB));
    
    return YES;
}

BOOL XUIAliasMethod(Class cls, char plusOrMinus, SEL originalSel, SEL aliasSel)
{
    BOOL result = NO;
    
    if (plusOrMinus == '+') {
        const char *clsName = class_getName(cls);
        cls = objc_getMetaClass(clsName);
    }
    
    Method method = class_getInstanceMethod(cls, originalSel);
    
    if (method) {
        IMP         imp    = method_getImplementation(method);
        const char *types  = method_getTypeEncoding(method);
        
        result = class_addMethod(cls, aliasSel, imp, types);
    }
    
#if DEBUG
    if (!result) {
        @autoreleasepool {
            NSLog(@"XUIAliasMethod(): could not alias '%@' to '%@'", NSStringFromSelector(originalSel), NSStringFromSelector(aliasSel));
        }
    }
#endif
    
    return result;
}

@interface EUUIKitImage : NSImage
{
    NSEdgeInsets _capInsets;
    NSImageResizingMode _resizingMode;
    NSArray *_imagePieces;
    NSBitmapImageRep *_cachedImageRep;
    NSSize _cachedImageSize;
    CGFloat _cachedImageDeviceScale;
}
@end
@implementation EUUIKitImage

-(id)initWithImage:(NSImage*)image leftCapWidth:(CGFloat)leftCapWidth topCapHeight:(CGFloat)topCapHeight{
    CGFloat rightCapWidth = image.size.width - leftCapWidth - 1.0f;
    CGFloat bottomCapHeight = image.size.height - topCapHeight - 1.0f;
    return [self initWithImage:image capInsets:NSEdgeInsetsMake(topCapHeight, leftCapWidth, bottomCapHeight, rightCapWidth)];
}

-(id)initWithImage:(NSImage*)image capInsets:(NSEdgeInsets)capInsets{
    return [self initWithImage:image capInsets:capInsets resizingMode:NSImageResizingModeTile];
}
-(id)initWithImage:(NSImage*)image capInsets:(NSEdgeInsets)capInsets resizingMode:(NSImageResizingMode)resizingMode{
    self = [super initWithData:[image TIFFRepresentation]];
    
    if (self){
        _capInsets = capInsets;
        _resizingMode = resizingMode;
        
        _imagePieces = EUNinePartPiecesFromImageWithInsets(self, _capInsets);
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    EUUIKitImage *ri = [super copyWithZone: zone];
    
    ri->_capInsets = _capInsets;
    ri->_imagePieces = _imagePieces;
    ri->_cachedImageRep = _cachedImageRep;
    ri->_cachedImageSize = _cachedImageSize;
    ri->_cachedImageDeviceScale = _cachedImageDeviceScale;
    ri->_resizingMode = _resizingMode;
    
    return ri;
}

#pragma mark - drawing
-(void)drawInRect:(NSRect)rect{
    [self drawInRect:rect operation:NSCompositeSourceOver fraction:1.0f];
}

-(void)drawInRect:(NSRect)rect operation:(NSCompositingOperation)op fraction:(CGFloat)requestedAlpha{
    [self drawInRect:rect operation:op fraction:requestedAlpha respectFlipped:YES hints:nil];
}
-(void)drawInRect:(NSRect)rect operation:(NSCompositingOperation)op fraction:(CGFloat)requestedAlpha respectFlipped:(BOOL)respectContextIsFlipped hints:(NSDictionary *)hints{
    [self drawInRect:rect fromRect:NSZeroRect operation:op fraction:requestedAlpha respectFlipped:YES hints:nil];
}

-(void)drawInRect:(NSRect)rect fromRect:(NSRect)fromRect operation:(NSCompositingOperation)op fraction:(CGFloat)requestedAlpha respectFlipped:(BOOL)respectContextIsFlipped hints:(NSDictionary *)hints{
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    //if our current cached image ref size does not match, throw away the cached image
    //we also treat the current contexts scale as an invalidator so we don't draw the old, cached result.
    if (!NSEqualSizes(rect.size, _cachedImageSize) || _cachedImageDeviceScale != EUContextGetDeviceScale(context)){
        _cachedImageRep = nil;
        _cachedImageSize = NSZeroSize;
        _cachedImageDeviceScale = 0.0f;
    }
    
    
    //if we don't have a cached image rep, create one now
    if (!_cachedImageRep){
        
        //cache our cache invalidation flags
        _cachedImageSize = rect.size;
        _cachedImageDeviceScale = EUContextGetDeviceScale(context);
        
        //create our own NSBitmapImageRep directly because calling -[NSImage lockFocus] and then drawing an
        //image causes it to use the largest available (ie @2x) image representation, even though our current
        //contexts scale is 1 (on non HiDPI screens) meaning that we inadvertently would use @2x assets to draw for @1x contexts
        _cachedImageRep =  [[NSBitmapImageRep alloc]
                            initWithBitmapDataPlanes:NULL
                            pixelsWide:_cachedImageSize.width * _cachedImageDeviceScale
                            pixelsHigh:_cachedImageSize.height * _cachedImageDeviceScale
                            bitsPerSample:8
                            samplesPerPixel:4
                            hasAlpha:YES
                            isPlanar:NO
                            colorSpaceName:[[[self representations] lastObject] colorSpaceName]
                            bytesPerRow:0
                            bitsPerPixel:32];
        [_cachedImageRep setSize:rect.size];
        
        if (!_cachedImageRep){
            NSLog(@"Error: failed to create NSBitmapImageRep from rep: %@", [[self representations] lastObject]);
            return;
        }
        
        NSGraphicsContext *newContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:_cachedImageRep];
        if (!newContext){
            NSLog(@"Error: failed to create NSGraphicsContext from rep: %@", _cachedImageRep);
            _cachedImageRep = nil;
            return;
        }
        
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:newContext];
        
        NSRect drawRect = NSMakeRect(0.0f, 0.0f, _cachedImageSize.width, _cachedImageSize.height);
        
        [[NSColor clearColor] setFill];
        NSRectFill(drawRect);
        
        
#if USE_RH_NINE_PART_IMAGE
        BOOL shouldTile = (_resizingMode == RHResizableImageResizingModeTile);
        RHDrawNinePartImage(drawRect,
                            [_imagePieces objectAtIndex:0], [_imagePieces objectAtIndex:1], [_imagePieces objectAtIndex:2],
                            [_imagePieces objectAtIndex:3], [_imagePieces objectAtIndex:4], [_imagePieces objectAtIndex:5],
                            [_imagePieces objectAtIndex:6], [_imagePieces objectAtIndex:7], [_imagePieces objectAtIndex:8],
                            NSCompositeSourceOver, 1.0f, shouldTile);
#else
        NSDrawNinePartImage(drawRect,
                            [_imagePieces objectAtIndex:0], [_imagePieces objectAtIndex:1], [_imagePieces objectAtIndex:2],
                            [_imagePieces objectAtIndex:3], [_imagePieces objectAtIndex:4], [_imagePieces objectAtIndex:5],
                            [_imagePieces objectAtIndex:6], [_imagePieces objectAtIndex:7], [_imagePieces objectAtIndex:8],
                            NSCompositeSourceOver, 1.0f, NO);
        
        //if we want a center stretch, we need to draw this separately, clearing center first
        //also note that this only stretches the center, if you also want all sides stretched,
        // you should use RHDrawNinePartImage() via USE_RH_NINE_PART_IMAGE = 1
        BOOL shouldStretch = (_resizingMode == NSImageResizingModeStretch);
        if (shouldStretch){
            NSImage *centerImage = [_imagePieces objectAtIndex:4];
            NSRect centerRect = NSRectFromCGRect(EUEdgeInsetsInsetRect(NSRectToCGRect(drawRect), _capInsets, NO));
            CGContextClearRect([[NSGraphicsContext currentContext] graphicsPort], NSRectToCGRect(centerRect));
            EUDrawStretchedImageInRect(centerImage, centerRect, NSCompositeSourceOver, 1.0f);
        }
        
#endif
        [NSGraphicsContext restoreGraphicsState];
    }
    
    //finally draw the cached image rep
    fromRect = NSMakeRect(0.0f, 0.0f, _cachedImageSize.width, _cachedImageSize.height);
    [_cachedImageRep drawInRect:rect fromRect:fromRect operation:op fraction:requestedAlpha respectFlipped:respectContextIsFlipped hints:hints];
    
}

CGRect EUEdgeInsetsInsetRect(CGRect rect, NSEdgeInsets insets, BOOL flipped){
    rect.origin.x    += insets.left;
    rect.origin.y    += flipped ? insets.top : insets.bottom;
    rect.size.width  -= (insets.left + insets.right);
    rect.size.height -= (insets.top  + insets.bottom);
    return rect;
}

void EUDrawStretchedImageInRect(NSImage* image, NSRect rect, NSCompositingOperation op, CGFloat fraction){
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);
    
    [[NSGraphicsContext currentContext] setCompositingOperation:op];
    CGContextSetAlpha(context, fraction);
    
    //we pass in the images actual size rather than rect. if we passed in rect directly, we would always get the @2x ref. (10.8s workaround for single axis stretching was -[NSImage matchesOnlyOnBestFittingAxis], however this wont work for stretching in 2 dimensions)
    NSRect outRect = NSMakeRect(0.0f, 0.0f, image.size.width, image.size.height);
    CGImageRef imageRef = [image CGImageForProposedRect:&outRect context:[NSGraphicsContext currentContext] hints:NULL];
    
    CGContextClipToRect(context, NSRectToCGRect(rect));
    CGContextDrawImage(context, NSRectToCGRect(rect), imageRef);
    
    CGContextRestoreGState(context);
}

CGFloat EUContextGetDeviceScale(CGContextRef context){
    CGSize backingSize = CGContextConvertSizeToDeviceSpace(context, CGSizeMake(1.0f, 1.0f));
    return backingSize.width;
}

NSImage* EUImageByReferencingRectOfExistingImage(NSImage *image, NSRect rect){
    NSImage *newImage = [[NSImage alloc] initWithSize:rect.size];
    if (!NSIsEmptyRect(rect)){
        //we operate on all of our NSBitmapImageRep representations; otherwise we loose either @1x or @2x representation
        for (NSBitmapImageRep *rep in image.representations) {
            //skip and non bitmap image reps
            if (![rep isKindOfClass:[NSBitmapImageRep class]]) continue;
            
            //scale the captureRect for the current representation because CGImage only works in pixels
            CGFloat scaleFactor =  rep.pixelsHigh / rep.size.height;
            CGRect captureRect = CGRectMake(scaleFactor * rect.origin.x, scaleFactor * rect.origin.y, scaleFactor * rect.size.width, scaleFactor * rect.size.height);
            
            //flip our y axis, because CGImage's origin is top-left
            captureRect.origin.y = rep.pixelsHigh - captureRect.origin.y - captureRect.size.height;
            
            CGImageRef cgImage = CGImageCreateWithImageInRect(rep.CGImage, captureRect);
            if (!cgImage){
                NSLog(@"RHImageByReferencingRectOfExistingImage: Error: Failed to create CGImage with CGImageCreateWithImageInRect() for imageRep:%@, rect:%@.", rep, NSStringFromRect(NSRectFromCGRect(captureRect)));
                continue;
            }
            
            //create a new BitmapImageRep for the new CGImage. The CGImage just points to the large image, so no pixels are copied by this operation
            NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgImage];
            [newRep setSize:rect.size];
            CGImageRelease(cgImage);
            [newImage addRepresentation:newRep];
        }
    }
    [newImage recache];
    return newImage;
}

NSArray* EUNinePartPiecesFromImageWithInsets(NSImage *image, NSEdgeInsets capInsets){
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat leftCapWidth = capInsets.left;
    CGFloat topCapHeight = capInsets.top;
    CGFloat rightCapWidth = capInsets.right;
    CGFloat bottomCapHeight = capInsets.bottom;
    
    NSSize centerSize = NSMakeSize(imageWidth - leftCapWidth - rightCapWidth, imageHeight - topCapHeight - bottomCapHeight);
    
    
    NSImage *topLeftCorner = EUImageByReferencingRectOfExistingImage(image, NSMakeRect(0.0f, imageHeight - topCapHeight, leftCapWidth, topCapHeight));
    NSImage *topEdgeFill = EUImageByReferencingRectOfExistingImage(image, NSMakeRect(leftCapWidth, imageHeight - topCapHeight, centerSize.width, topCapHeight));
    NSImage *topRightCorner = EUImageByReferencingRectOfExistingImage(image, NSMakeRect(imageWidth - rightCapWidth, imageHeight - topCapHeight, rightCapWidth, topCapHeight));
    
    NSImage *leftEdgeFill = EUImageByReferencingRectOfExistingImage(image, NSMakeRect(0.0f, bottomCapHeight, leftCapWidth, centerSize.height));
    NSImage *centerFill = EUImageByReferencingRectOfExistingImage(image, NSMakeRect(leftCapWidth, bottomCapHeight, centerSize.width, centerSize.height));
    NSImage *rightEdgeFill = EUImageByReferencingRectOfExistingImage(image, NSMakeRect(imageWidth - rightCapWidth, bottomCapHeight, rightCapWidth, centerSize.height));
    
    NSImage *bottomLeftCorner = EUImageByReferencingRectOfExistingImage(image, NSMakeRect(0.0f, 0.0f, leftCapWidth, bottomCapHeight));
    NSImage *bottomEdgeFill = EUImageByReferencingRectOfExistingImage(image, NSMakeRect(leftCapWidth, 0.0f, centerSize.width, bottomCapHeight));
    NSImage *bottomRightCorner = EUImageByReferencingRectOfExistingImage(image, NSMakeRect(imageWidth - rightCapWidth, 0.0f, rightCapWidth, bottomCapHeight));
    
    return [NSArray arrayWithObjects:topLeftCorner, topEdgeFill, topRightCorner, leftEdgeFill, centerFill, rightEdgeFill, bottomLeftCorner, bottomEdgeFill, bottomRightCorner, nil];
}
@end

@implementation NSImage (ImageEffects)
- (NSImage *)imageWithRoundedCornersSize:(float)cornerRadius
{
    NSSize existingSize = [self size];
    if (CGSizeEqualToSize(NSSizeToCGSize(existingSize), CGSizeZero)){
        return nil;
    }
    NSSize newSize = NSMakeSize(existingSize.width, existingSize.height);
    NSImage *composedImage = [[NSImage alloc] initWithSize:newSize];
    
    [composedImage lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    
    NSRect imageFrame = NSMakeRect(0, 0, existingSize.width, existingSize.height);
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:imageFrame xRadius:cornerRadius yRadius:cornerRadius];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    
    [self drawAtPoint:NSZeroPoint fromRect:NSMakeRect(0, 0, newSize.width, newSize.height) operation:NSCompositeSourceOver fraction:1];
    
    [composedImage unlockFocus];
    
    return composedImage;
}

- (NSImage *)imageWithRoundedCorners:(UIRectCorner)corners cornerRadius:(float)cornerRadius
{
//    CGRect frame = CGRectMake(0, 0, self.size.width, self.size.height);
//    UIGraphicsBeginImageContextWithOptions(self.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [[NSBezierPath bezierPathWithRoundedRect:frame
//                           byRoundingCorners:corners
//                                 cornerRadii:CGSizeMake(cornerRadius, cornerRadius)] addClip];
//    [self drawInRect:frame];
//    CGImageRef imageRef = CGBitmapContextCreateImage(context);
//    NSImage* newImage = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(CGBitmapContextGetWidth(context),CGBitmapContextGetHeight(context))];
//    UIGraphicsEndImageContext();
//    return newImage;
    return nil;
}

- (NSImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight
{
    return [[EUUIKitImage alloc] initWithImage:self leftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}

- (NSImage *)imageCompressedByFactor:(float)factor
{
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithData:[self TIFFRepresentation]];
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:factor] forKey:NSImageCompressionFactor];
    NSData *compressedData = [imageRep representationUsingType:NSJPEGFileType properties:options];
    return [[NSImage alloc] initWithData:compressedData];
}

+ (NSImage *)imageWithColor:(NSColor *)color
{
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContextWithOptions(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//
//    CGImageRef imageRef = CGBitmapContextCreateImage(context);
//    NSImage* newImage = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(CGBitmapContextGetWidth(context),CGBitmapContextGetHeight(context))];
//    UIGraphicsEndImageContext();
//    return newImage;
    return nil;
}

- (NSImage *)scaleImageInRect:(CGRect)rect
{
//    UIGraphicsBeginImageContextWithOptions(rect.size);
//    [self drawInRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGImageRef imageRef = CGBitmapContextCreateImage(context);
//    NSImage* newImage = [[NSImage alloc] initWithCGImage:imageRef size:NSMakeSize(CGBitmapContextGetWidth(context),CGBitmapContextGetHeight(context))];
//    UIGraphicsEndImageContext();
//    return newImage;
    return nil;
}
@end


@implementation NSBezierPath (XUIKitAdditions_Implementation)

+ (void) load
{
    Class cls = [NSBezierPath class];
    
    XUIAliasMethod(cls, '+', @selector(xui_bezierPathWithRoundedRect:cornerRadius:),                        @selector(bezierPathWithRoundedRect:cornerRadius:));
    XUIAliasMethod(cls, '+', @selector(xui_bezierPathWithRoundedRect:byRoundingCorners:cornerRadii:),       @selector(bezierPathWithRoundedRect:byRoundingCorners:cornerRadii:));
    XUIAliasMethod(cls, '+', @selector(xui_bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:),  @selector(bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:));
    XUIAliasMethod(cls, '+', @selector(xui_bezierPathWithCGPath:),                                          @selector(bezierPathWithCGPath:));
    
    XUIAliasMethod(cls, '-', @selector(xui_addQuadCurveToPoint:controlPoint:),                              @selector(addQuadCurveToPoint:controlPoint:));
    XUIAliasMethod(cls, '-', @selector(xui_addArcWithCenter:radius:startAngle:endAngle:clockwise:),         @selector(addArcWithCenter:radius:startAngle:endAngle:clockwise:));
    XUIAliasMethod(cls, '-', @selector(xui_applyTransform:),                                                @selector(applyTransform:));
    XUIAliasMethod(cls, '-', @selector(xui_fillWithBlendMode:alpha:),                                       @selector(fillWithBlendMode:alpha:));
    XUIAliasMethod(cls, '-', @selector(xui_strokeWithBlendMode:alpha:),                                     @selector(strokeWithBlendMode:alpha:));
    XUIAliasMethod(cls, '-', @selector(xui_setCGPath:),                                                     @selector(setCGPath:));
    XUIAliasMethod(cls, '-', @selector(xui_setUsesEvenOddFillRule:),                                        @selector(setUsesEvenOddFillRule:));
    XUIAliasMethod(cls, '-', @selector(xui_usesEvenOddFillRule),                                            @selector(usesEvenOddFillRule));
    
    XUIAliasMethod(cls, '-', @selector(lineToPoint:),                                                       @selector(addLineToPoint:));
    XUIAliasMethod(cls, '-', @selector(curveToPoint:controlPoint1:controlPoint2:),                          @selector(addCurveToPoint:controlPoint1:controlPoint2:));
    XUIAliasMethod(cls, '-', @selector(appendBezierPath:),                                                  @selector(appendPath:));
    
    // -[NSBezierPath CGPath] is in 10.10, but as private API.  Avoid runtime warning.
    // <rdar://19094891> -[NSBezierPath CGPath] should be public API
    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_9) {
        XUIAliasMethod(cls, '-', @selector(xui_CGPath), @selector(CGPath));
    }else{
        XUISwizzleMethod(cls, '-', @selector(xui_CGPath), @selector(CGPath));
    }
}


+ (NSBezierPath *) xui_bezierPathWithRoundedRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    return [NSBezierPath bezierPathWithRoundedRect:rect xRadius:cornerRadius yRadius:cornerRadius];
}


+ (NSBezierPath *) xui_bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(XUIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    const CGPoint topLeft = rect.origin;
    const CGPoint topRight = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    const CGPoint bottomRight = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    const CGPoint bottomLeft = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    
    if (corners & XUIRectCornerTopLeft) {
        CGPathMoveToPoint(path, NULL, topLeft.x+cornerRadii.width, topLeft.y);
    } else {
        CGPathMoveToPoint(path, NULL, topLeft.x, topLeft.y);
    }
    
    if (corners & XUIRectCornerTopRight) {
        CGPathAddLineToPoint(path, NULL, topRight.x-cornerRadii.width, topRight.y);
        CGPathAddCurveToPoint(path, NULL, topRight.x, topRight.y, topRight.x, topRight.y+cornerRadii.height, topRight.x, topRight.y+cornerRadii.height);
    } else {
        CGPathAddLineToPoint(path, NULL, topRight.x, topRight.y);
    }
    
    if (corners & XUIRectCornerBottomRight) {
        CGPathAddLineToPoint(path, NULL, bottomRight.x, bottomRight.y-cornerRadii.height);
        CGPathAddCurveToPoint(path, NULL, bottomRight.x, bottomRight.y, bottomRight.x-cornerRadii.width, bottomRight.y, bottomRight.x-cornerRadii.width, bottomRight.y);
    } else {
        CGPathAddLineToPoint(path, NULL, bottomRight.x, bottomRight.y);
    }
    
    if (corners & XUIRectCornerBottomLeft) {
        CGPathAddLineToPoint(path, NULL, bottomLeft.x+cornerRadii.width, bottomLeft.y);
        CGPathAddCurveToPoint(path, NULL, bottomLeft.x, bottomLeft.y, bottomLeft.x, bottomLeft.y-cornerRadii.height, bottomLeft.x, bottomLeft.y-cornerRadii.height);
    } else {
        CGPathAddLineToPoint(path, NULL, bottomLeft.x, bottomLeft.y);
    }
    
    if (corners & XUIRectCornerTopLeft) {
        CGPathAddLineToPoint(path, NULL, topLeft.x, topLeft.y+cornerRadii.height);
        CGPathAddCurveToPoint(path, NULL, topLeft.x, topLeft.y, topLeft.x+cornerRadii.width, topLeft.y, topLeft.x+cornerRadii.width, topLeft.y);
    } else {
        CGPathAddLineToPoint(path, NULL, topLeft.x, topLeft.y);
    }
    
    CGPathCloseSubpath(path);
    
    NSBezierPath *result = [NSBezierPath bezierPath];
    [result setCGPath:path];
    CGPathRelease(path);
    
    return result;
}

#define EudicUIKitAngle(radian) (radian / M_PI * 180.f)
+ (NSBezierPath *) xui_bezierPathWithArcCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    CGFloat start = EudicUIKitAngle(startAngle);
    CGFloat end = EudicUIKitAngle(endAngle);
    [path appendBezierPathWithArcWithCenter:center radius:radius startAngle:start endAngle:end clockwise:!clockwise];
    return path;
}


+ (NSBezierPath *) xui_bezierPathWithCGPath:(CGPathRef)inPath
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setCGPath:inPath];
    return path;
}


- (void) xui_addQuadCurveToPoint:(CGPoint)QP2 controlPoint:(CGPoint)QP1
{
    // See http://fontforge.sourceforge.net/bezier.html
    
    CGPoint QP0 = [self currentPoint];
    CGPoint CP3 = QP2;
    
    CGPoint CP1 = CGPointMake(
                              //  QP0   +   2   / 3    * (QP1   - QP0  )
                              QP0.x + ((2.0 / 3.0) * (QP1.x - QP0.x)),
                              QP0.y + ((2.0 / 3.0) * (QP1.y - QP0.y))
                              );
    
    CGPoint CP2 = CGPointMake(
                              //  QP2   +  2   / 3    * (QP1   - QP2)
                              QP2.x + (2.0 / 3.0) * (QP1.x - QP2.x),
                              QP2.y + (2.0 / 3.0) * (QP1.y - QP2.y)
                              );
    
    [self curveToPoint:CP3 controlPoint1:CP1 controlPoint2:CP2];
}


- (void) xui_addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise
{
    [self appendBezierPathWithArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
}


- (void) xui_applyTransform:(CGAffineTransform)transform
{
    NSAffineTransform *nsTransform = [NSAffineTransform transform];
    
    NSAffineTransformStruct transformStruct = {
        transform.a,  transform.b, transform.c, transform.d,
        transform.tx, transform.ty
    };
    
    [nsTransform setTransformStruct:transformStruct];
    [self transformUsingAffineTransform:nsTransform];
}


- (void) xui_fillWithBlendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);
    
    CGContextSetBlendMode(context, blendMode);
    CGContextSetAlpha(context, alpha);
    
    [self fill];
    
    CGContextRestoreGState(context);
}


- (void) xui_strokeWithBlendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);
    
    CGContextSetBlendMode(context, blendMode);
    CGContextSetAlpha(context, alpha);
    
    [self stroke];
    
    CGContextRestoreGState(context);
}


static void sPathApplier(void *info, const CGPathElement *element)
{
    NSBezierPath *path = (__bridge NSBezierPath *)info;
    
    switch (element->type) {
        case kCGPathElementMoveToPoint:
            [path moveToPoint:element->points[0]];
            break;
            
        case kCGPathElementAddLineToPoint:
            [path lineToPoint:element->points[0]];
            break;
            
        case kCGPathElementAddQuadCurveToPoint:
            [path addQuadCurveToPoint: element->points[1]
                         controlPoint: element->points[0]];
            
            break;
            
        case kCGPathElementAddCurveToPoint:
            [path curveToPoint: element->points[2]
                 controlPoint1: element->points[0]
                 controlPoint2: element->points[1]];
            
            break;
            
        case kCGPathElementCloseSubpath:
            [path closePath];
            break;
    }
}


- (void) xui_setCGPath:(CGPathRef)CGPath
{
    [self removeAllPoints];
    if (CGPathIsEmpty(CGPath)) return;
    
    CGPathApply(CGPath, (__bridge void *)self, sPathApplier);
}


- (CGPathRef) xui_CGPath
{
    //https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CocoaDrawingGuide/Paths/Paths.html#//apple_ref/doc/uid/TP40003290-CH206-SW2
    CGMutablePathRef path = CGPathCreateMutable();
    NSPoint p[3];
    BOOL closed = NO;
    
    NSInteger elementCount = [self elementCount];
    for (NSInteger i = 0; i < elementCount; i++) {
        switch ([self elementAtIndex:i associatedPoints:p]) {
            case NSMoveToBezierPathElement:
                CGPathMoveToPoint(path, NULL, p[0].x, p[0].y);
                break;
                
            case NSLineToBezierPathElement:
                CGPathAddLineToPoint(path, NULL, p[0].x, p[0].y);
                closed = NO;
                break;
                
            case NSCurveToBezierPathElement:
                CGPathAddCurveToPoint(path, NULL, p[0].x, p[0].y, p[1].x, p[1].y, p[2].x, p[2].y);
                closed = NO;
                break;
                
            case NSClosePathBezierPathElement:
                CGPathCloseSubpath(path);
                closed = YES;
                break;
        }
    }
    
    //    if (!closed)  CGPathCloseSubpath(path);
    
    CGPathRef immutablePath = CGPathCreateCopy(path);
    objc_setAssociatedObject(self, "XUIKit_CGPath", (__bridge id)immutablePath, OBJC_ASSOCIATION_RETAIN);
    CGPathRelease(immutablePath);
    
    CGPathRelease(path);
    
    return (__bridge CGPathRef)objc_getAssociatedObject(self, "XUIKit_CGPath");
}


- (void) xui_setUsesEvenOddFillRule:(BOOL)yn
{
    [self setWindingRule:yn ? NSEvenOddWindingRule : NSNonZeroWindingRule];
}


- (BOOL) xui_usesEvenOddFillRule
{
    return [self windingRule] == NSEvenOddWindingRule;
}


@end


@interface XUIBezierPath : NSBezierPath
@end


@implementation XUIBezierPath : NSBezierPath
- (CGPathRef) CGPath { return [self xui_CGPath]; }
@end
