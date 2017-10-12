//
//  UIViewController.m
//  ting_macOS
//
//  Created by cube on 2017/1/9.
//  Copyright © 2017年 cube. All rights reserved.
//

#import "UIViewController.h"

@implementation UIBarButtonItem
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {return nil;}
- (instancetype)initWithImage:(nullable NSImage *)image style:(UIBarButtonItemStyle)style target:(nullable id)target action:(nullable SEL)action {return nil;}
- (instancetype)initWithImage:(nullable NSImage *)image landscapeImagePhone:(nullable NSImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(nullable id)target action:(nullable SEL)action{return nil;}
- (instancetype)initWithTitle:(nullable NSString *)title style:(UIBarButtonItemStyle)style target:(nullable id)target action:(nullable SEL)action{return nil;}
- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(nullable id)target action:(nullable SEL)action{return nil;}
- (instancetype)initWithCustomView:(NSView *)customView{return nil;}
@end

@implementation UINavigationItem

@end

@implementation UINavigationController

@end

@interface UIViewController ()

@end

@implementation UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (UINavigationController *)navigationController
{
    return self;
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    
}

@end
