//
//  UICollectionView.h
//  ting_macOS
//
//  Created by cube on 22/05/2017.
//  Copyright © 2017 cube. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UITableView.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const UICollectionElementKindSectionHeader = @"UICollectionElementKindSectionHeader";
static NSString *const UICollectionElementKindSectionFooter = @"UICollectionElementKindSectionFooter";

@interface UICollectionViewLayoutAttributes : NSCollectionViewLayoutAttributes
+ (instancetype)layoutAttributesForCellWithIndexPath:(NSIndexPath *)indexPath;
@end

@interface UICollectionViewFlowLayout : NSCollectionViewFlowLayout

@end

@interface UICollectionViewLayout : NSCollectionViewLayout

@end

@protocol UICollectionViewDataSource <NSCollectionViewDataSource> @end
@protocol UICollectionViewDelegate <NSCollectionViewDelegate> @end
@interface UICollectionReusableView : NSView
- (void)setNeedsLayout;
@property(nullable, nonatomic,copy)            NSColor          *backgroundColor ;
@property (nonatomic) CGFloat alpha;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@end

@interface UICollectionViewCell : NSCollectionViewItem
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property(nonatomic,readonly,strong)                 CALayer  *layer;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic) CGRect frame;
@property (nonatomic) CGRect bounds;
@property(nullable, nonatomic,copy)            NSColor          *backgroundColor ;
@property (nonatomic, strong) UIView *contentView;
- (void)setNeedsLayout;
- (void)layoutIfNeeded;
@end

typedef NS_ENUM(NSUInteger, UICollectionViewScrollPosition) {
    UICollectionViewScrollPositionNone                 ,
    
    // The vertical positions are mutually exclusive to each other, but are bitwise or-able with the horizontal scroll positions.
    // Combining positions from the same grouping (horizontal or vertical) will result in an NSInvalidArgumentException.
    UICollectionViewScrollPositionTop                  ,
    UICollectionViewScrollPositionCenteredVertically   ,
    UICollectionViewScrollPositionBottom               ,
    
    // Likewise, the horizontal positions are mutually exclusive to each other.
    UICollectionViewScrollPositionLeft                 ,
    UICollectionViewScrollPositionCenteredHorizontally ,
    UICollectionViewScrollPositionRight                
};

@interface UICollectionView : NSCollectionView
@property (strong, nonatomic) MJRefreshHeader  * _Nullable mj_header;
@property (strong, nonatomic) MJRefreshFooter  * _Nullable mj_footer;
@property (nonatomic, copy) NSColor *backgroundColor;
- (void)selectItemAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition;
- (void)setNeedsLayout;
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (nullable UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (__kindof UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
@end

@interface UICollectionViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
