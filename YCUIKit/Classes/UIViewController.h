//
//  UIViewController.h
//  ting_macOS
//
//  Created by cube on 2017/1/9.
//  Copyright © 2017年 cube. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, UIBarButtonItemStyle) {
    UIBarButtonItemStylePlain,
    UIBarButtonItemStyleBordered,
    UIBarButtonItemStyleDone,
};

typedef NS_ENUM(NSInteger, UIBarButtonSystemItem) {
    UIBarButtonSystemItemDone,
    UIBarButtonSystemItemCancel,
    UIBarButtonSystemItemEdit,
    UIBarButtonSystemItemSave,
    UIBarButtonSystemItemAdd,
    UIBarButtonSystemItemFlexibleSpace,
    UIBarButtonSystemItemFixedSpace,
    UIBarButtonSystemItemCompose,
    UIBarButtonSystemItemReply,
    UIBarButtonSystemItemAction,
    UIBarButtonSystemItemOrganize,
    UIBarButtonSystemItemBookmarks,
    UIBarButtonSystemItemSearch,
    UIBarButtonSystemItemRefresh,
    UIBarButtonSystemItemStop,
    UIBarButtonSystemItemCamera,
    UIBarButtonSystemItemTrash,
    UIBarButtonSystemItemPlay,
    UIBarButtonSystemItemPause,
    UIBarButtonSystemItemRewind,
    UIBarButtonSystemItemFastForward,
    UIBarButtonSystemItemUndo,
    UIBarButtonSystemItemRedo,
    UIBarButtonSystemItemPageCurl,
};

@interface UIBarButtonItem : NSControl
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder;
- (instancetype)initWithImage:(nullable NSImage *)image style:(UIBarButtonItemStyle)style target:(nullable id)target action:(nullable SEL)action;
- (instancetype)initWithImage:(nullable NSImage *)image landscapeImagePhone:(nullable NSImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(nullable id)target action:(nullable SEL)action; // landscapeImagePhone will be used for the bar button image when the bar has Compact or Condensed bar metrics.
- (instancetype)initWithTitle:(nullable NSString *)title style:(UIBarButtonItemStyle)style target:(nullable id)target action:(nullable SEL)action;
- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(nullable id)target action:(nullable SEL)action;
- (instancetype)initWithCustomView:(NSView *)customView;
@property (nonatomic, copy) NSString *title;
@end


@interface UINavigationItem : NSObject
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@end

@class UINavigationController;
@interface UIViewController : NSViewController
@property (nonatomic) BOOL hidesBottomBarWhenPushed;
@property (nonatomic, strong, readonly) UINavigationController *navigationController;
@property (nonatomic, strong) UINavigationItem *navigationItem; // Created on-demand so that a view controller may customize its navigation appearance.

@property(nullable, nonatomic,strong) UIBarButtonItem *leftBarButtonItem;
@property(nullable, nonatomic,strong) UIBarButtonItem *rightBarButtonItem;
- (void)setLeftBarButtonItem:(nullable UIBarButtonItem *)item animated:(BOOL)animated;
- (void)setRightBarButtonItem:(nullable UIBarButtonItem *)item animated:(BOOL)animated;

- (void)didMoveToParentViewController:(nullable UIViewController *)parent;
@end

@interface UINavigationController : UIViewController

@end
