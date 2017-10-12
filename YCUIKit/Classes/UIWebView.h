//
//  UIWebView.h
//  ting_macOS
//
//  Created by cube on 2017/1/13.
//  Copyright © 2017年 cube. All rights reserved.
//

#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIWebView : WebView
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
- (BOOL)endEditing:(BOOL)force;
@end

@protocol EuWebTableViewCellDelegate <NSObject>
- (void)heightUpdate:(int)height;
- (BOOL)shouldStartLoadWithRequest:(NSURLRequest *)request;
- (void)cellDidFinishLoad;
@end
@interface EuWebTableViewCell : NSTableCellView
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic) int contentHeight;
@property (nonatomic, weak) id<EuWebTableViewCellDelegate> delegate;
@end
NS_ASSUME_NONNULL_END
