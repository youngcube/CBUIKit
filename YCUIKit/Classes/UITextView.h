//
//  UITextView.h
//  ting_macOS
//
//  Created by cube on 2017/1/17.
//  Copyright © 2017年 cube. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define UIEdgeInsetsZero NSEdgeInsetsZero
NS_INLINE NSEdgeInsets UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    NSEdgeInsets e;
    e.top = top;
    e.left = left;
    e.bottom = bottom;
    e.right = right;
    return e;
}

@interface UITextView : NSTextView
@property(null_resettable,nonatomic,copy) NSString *text;
@property(nonatomic) NSTextAlignment textAlignment;
@property(null_resettable,nonatomic,copy) NSAttributedString *attributedText;
@property(nonatomic) BOOL scrollEnabled;
@property(nonatomic) NSEdgeInsets contentInset;
@end
