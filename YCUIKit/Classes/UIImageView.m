//
//  UIImageView.m
//  ting_macOS
//
//  Created by cube on 2017/1/9.
//  Copyright © 2017年 cube. All rights reserved.
//

#import "UIImageView.h"

NSData *UIImagePNGRepresentation(NSImage *image)
{
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
    CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:maskRef];
    
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                [NSNumber numberWithBool:YES], NSImageProgressive, nil]];
    return pngData;
}

NSData *UIImageJPEGRepresentation(NSImage *image, float quality)
{
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
    CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:maskRef];
    
    NSNumber *compressionFactor = [NSNumber numberWithFloat:quality];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:compressionFactor
                                                           forKey:NSImageCompressionFactor];
    
    NSData *jpgData = [newRep representationUsingType:NSJPEGFileType properties:imageProps];
    return jpgData;
}

@implementation UIImageView

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self){
        [self setImage:image];
    }
    return self;
}

- (void)setAlpha:(CGFloat)alpha
{
    _alpha = alpha;
    self.alphaValue = alpha;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.wantsLayer = YES;
    self.layer.backgroundColor = backgroundColor.CGColor;
}

- (void)startAnimating
{
    
}

- (void)stopAnimating
{
    
}
@end
