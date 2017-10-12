//
//  UILabel.h
//  ting_macOS
//
//  Created by cube on 2017/1/9.
//  Copyright © 2017年 cube. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UILabel : NSTextField
@property (nonatomic, copy) NSString *text;
@property (nonatomic) NSInteger numberOfLines;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGSize size;
@property (nonatomic,copy) NSAttributedString *attributedText;
@end

@interface UITextField : NSTextField
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@end

@interface EUCenterLabel : UILabel

@end
