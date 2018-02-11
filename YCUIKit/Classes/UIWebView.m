//
//  UIWebView.m
//  ting_macOS
//
//  Created by cube on 2017/1/13.
//  Copyright © 2017年 cube. All rights reserved.
//

#import "UIWebView.h"

@implementation UIWebView

- (void)loadRequest:(NSURLRequest *)request
{
    [self.mainFrame loadRequest:request];
}

- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL
{
    [self.mainFrame loadHTMLString:string baseURL:baseURL];
}

- (BOOL)endEditing:(BOOL)force
{
    return YES;
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler
{
    [self stringByEvaluatingJavaScriptFromString:javaScriptString];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString
{
    [self stringByEvaluatingJavaScriptFromString:javaScriptString];
}

@end
@interface EuWebTableViewCell () <WebPolicyDelegate, WebFrameLoadDelegate>

@end
@implementation EuWebTableViewCell
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

- (void)commonInit
{
    _webView = [[UIWebView alloc] init];
    _webView.policyDelegate = self;
    _webView.frameLoadDelegate = self;
    _webView.autoresizingMask = NSViewNotSizable;
    
    [self addSubview:_webView];
}

- (void)layout
{
    [super layout];
    if (self.bounds.size.width > 0 && self.bounds.size.height > 0){
        self.webView.frame = self.bounds;
    }
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
    BOOL use = YES;
    if ([self.delegate respondsToSelector:@selector(shouldStartLoadWithRequest:)]){
        use = [self.delegate shouldStartLoadWithRequest:request];
    }
    if (use){
        [listener use];
    }else{
        [listener ignore];
    }
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    self.contentHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"getBodyHeight();"] intValue];
    self.contentHeight = fmax(10.0, self.contentHeight);
    if ([self.delegate respondsToSelector:@selector(heightUpdate:)]){
        [self.delegate heightUpdate:self.contentHeight];
    }
    if ([self.delegate respondsToSelector:@selector(cellDidFinishLoad)]){
        [self.delegate cellDidFinishLoad];
    }
}

- (void)dealloc
{
    [_webView stopLoading:nil];
    _webView.policyDelegate = nil;
    _webView.frameLoadDelegate = nil;
}

@end
