//
//  UIActivityIndicatorView.h
//  ting_macOS
//
//  Created by cube on 2017/1/16.
//  Copyright © 2017年 cube. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef NS_ENUM(NSInteger, UIActivityIndicatorViewStyle) {
    UIActivityIndicatorViewStyleWhiteLarge,
    UIActivityIndicatorViewStyleWhite,
    UIActivityIndicatorViewStyleGray __TVOS_PROHIBITED,
};
@interface UIActivityIndicatorView : NSProgressIndicator

- (instancetype)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style NS_DESIGNATED_INITIALIZER; // sizes the view according to the style
- (void)startAnimating;
- (void)stopAnimating;
@property(nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
