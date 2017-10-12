//
//  UITextView.m
//  ting_macOS
//
//  Created by cube on 2017/1/17.
//  Copyright © 2017年 cube. All rights reserved.
//

#import "UITextView.h"

@implementation UITextView

- (void)setText:(NSString *)text
{
    if (text){
        [self setString:text];
    }else{
        [self setString:@""];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText;
    [self.textStorage setAttributedString:attributedText];
}

- (NSString *)text
{
    return self.string;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.alignment = textAlignment;
}

- (NSTextAlignment)textAlignment
{
    return self.alignment;
}

@end
