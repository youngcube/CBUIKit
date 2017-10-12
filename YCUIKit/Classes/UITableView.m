//
//  UITableView.m
//  ting_macOS
//
//  Created by cube on 2017/1/23.
//  Copyright © 2017年 cube. All rights reserved.
//

#import "UITableView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView.h"

@implementation NSBundle(UINibLoadingAdditions)
- (NSArray *)loadNibNamed:(NSString *)name owner:(id)owner options:(NSDictionary *)options
{
    NSArray *array;
    [self loadNibNamed:name owner:owner topLevelObjects:&array];
    NSMutableArray *mutableArray = array.mutableCopy;
    for (int i = 0; i < mutableArray.count; i++){
        id obj = mutableArray[i];
        if ([obj isKindOfClass:NSApplication.class]){
            [mutableArray removeObject:obj];
        }
    }
    return mutableArray;
}
@end

NSString * const UITableViewIndexSearch = @"{search}";
CGFloat const UITableViewAutomaticDimension = 80;


@implementation MJRefreshComponent
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action { return nil; }
- (void)endRefreshing {}
@end

@implementation MJRefreshHeader
@end

@implementation MJRefreshFooter
@end

@implementation MJRefreshNormalHeader

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshHeader *cmp = [[self alloc] init];
//    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

@end

@implementation UIScrollView
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self){
        [self p_scrollView_commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self){
        [self p_scrollView_commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self){
        [self p_scrollView_commonInit];
    }
    return self;
}


- (void)p_scrollView_commonInit
{
    self.wantsLayer = YES;
    self.drawsBackground = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidLiveScroll:) name:NSScrollViewDidLiveScrollNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewWillStartLiveMaginfy:) name:NSScrollViewWillStartLiveMagnifyNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidEndLiveMaginfy:) name:NSScrollViewDidEndLiveMagnifyNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewWillStartLiveScroll:) name:NSScrollViewWillStartLiveScrollNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidEndLiveScroll:) name:NSScrollViewDidEndLiveScrollNotification object:self];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidLiveScroll:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.delegate scrollViewDidScroll:self];
    }
}

- (void)scrollViewWillStartLiveMaginfy:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]){
        [self.delegate scrollViewWillBeginZooming:self withView:self];
    }
}

- (void)scrollViewDidEndLiveMaginfy:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]){
        [self.delegate scrollViewDidEndZooming:self withView:self atScale:1];
    }
}

- (void)scrollViewWillStartLiveScroll:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.delegate scrollViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidEndLiveScroll:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.delegate scrollViewDidEndDecelerating:self];
    }
}

- (void)setContentSize:(CGSize)contentSize
{
    [self.documentView setFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height)];
}

- (void)bringSubviewToFront:(NSView *)view
{
    NSView *superview = [view superview];
    [view removeFromSuperview];
    [superview addSubview:view];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    [self.documentView scrollPoint:contentOffset];
}

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = duration;
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        if (animations){
            animations();
        }
    } completionHandler:^{
        
    }];
}

- (BOOL)isFlipped
{
    return YES;
}
@end
@interface UITableViewCell ()
@property (nonatomic, strong) NSIndexPath *p_indexPath;
@property (nonatomic, strong, readwrite) UIView *contentView;
@end
@implementation UITableViewCell

static void UITableViewCellCommonInit(UITableViewCell *tableViewCell) {
    tableViewCell.contentView = [[UIView alloc] init];
    [tableViewCell addSubview:tableViewCell.contentView];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:tableViewCell.contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:tableViewCell attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:tableViewCell.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:tableViewCell attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:tableViewCell.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:tableViewCell attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:tableViewCell.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tableViewCell attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [tableViewCell addConstraints:@[leading,trailing,top,bottom]];
    
    tableViewCell.translatesAutoresizingMaskIntoConstraints = NO;
    tableViewCell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:NSZeroRect];
    if (self){
        UITableViewCellCommonInit(self);
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        UITableViewCellCommonInit(self);
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:NSZeroRect];
    if (self){
        UITableViewCellCommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self){
        UITableViewCellCommonInit(self);
    }
    return self;
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)setNeedsDisplay
{
    self.needsDisplay = YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self setEditing:editing];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [self setHighlighted:highlighted];
}

@end

@interface UITableViewRowAction()
@property (nonatomic, readwrite) UITableViewRowActionStyle style;
@property (nonatomic, copy) void (^handlerBlock)(UITableViewRowAction *, NSIndexPath *);
@end

@implementation UITableViewRowAction

+ (instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style title:(NSString *)title handler:(void (^)(UITableViewRowAction *, NSIndexPath *))handler
{
    UITableViewRowAction *rowAction = [[UITableViewRowAction alloc] init];
    rowAction.title = title;
    rowAction.style = style;
    rowAction.handlerBlock = handler;
    return rowAction;
}

@end

@interface UITableView () <NSOutlineViewDelegate, NSOutlineViewDataSource, NSMenuDelegate>
{
    struct {
        unsigned heightForRowAtIndexPath : 1;
        unsigned heightForHeaderInSection : 1;
        unsigned heightForFooterInSection : 1;
        unsigned viewForHeaderInSection : 1;
        unsigned viewForFooterInSection : 1;
        unsigned willSelectRowAtIndexPath : 1;
        unsigned didSelectRowAtIndexPath : 1;
        unsigned willDeselectRowAtIndexPath : 1;
        unsigned didDeselectRowAtIndexPath : 1;
        unsigned willBeginEditingRowAtIndexPath : 1;
        unsigned didEndEditingRowAtIndexPath : 1;
        unsigned titleForDeleteConfirmationButtonForRowAtIndexPath: 1;
    } _delegateHas;
    
    struct {
        unsigned numberOfSectionsInTableView : 1;
        unsigned titleForHeaderInSection : 1;
        unsigned titleForFooterInSection : 1;
        unsigned commitEditingStyle : 1;
        unsigned canEditRowAtIndexPath : 1;
    } _dataSourceHas;
}

@property (nonatomic, readwrite) NSInteger numberOfSections;
@property (nonatomic, strong) NSMutableDictionary *cacheCells;
@property (nonatomic, strong) NSMutableDictionary *cacheIndexs;
@property (nonatomic, strong) NSMenu *rightMenu;
@end

@implementation UITableView

static void UITableViewCommonInit(UITableView *tableView) {
    
    if (tableView.inner_outlineView){
        return;
    }
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.inner_outlineView = [[NSOutlineView alloc] init];
    tableView.inner_outlineView.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
    tableView.inner_outlineView.delegate = tableView;
    tableView.inner_outlineView.dataSource = tableView;
    tableView.inner_outlineView.headerView = nil;
    tableView.inner_outlineView.rowSizeStyle = NSTableViewRowSizeStyleLarge;
    tableView.inner_outlineView.floatsGroupRows = NO;
    [tableView.inner_outlineView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    NSTableColumn *col = [[NSTableColumn alloc] initWithIdentifier:@""];
    [col setResizingMask:NSTableColumnAutoresizingMask];
    [tableView.inner_outlineView addTableColumn:col];
    [tableView setDocumentView:tableView.inner_outlineView];
    
    tableView.hasVerticalScroller = YES;
    tableView.hasHorizontalScroller = NO;
    tableView.automaticallyAdjustsContentInsets = NO;
    [tableView.inner_outlineView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
    [tableView.inner_outlineView sizeLastColumnToFit];
    
    tableView.rightMenu = [[NSMenu alloc] init];
    tableView.rightMenu.delegate = tableView;
    tableView.inner_outlineView.menu = tableView.rightMenu;
    
    tableView.cacheCells = [NSMutableDictionary dictionary];
    tableView.cacheIndexs = [NSMutableDictionary dictionary];
}

- (instancetype)init
{
    if (self = [super init]){
        UITableViewCommonInit(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]){
        
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]){
        UITableViewCommonInit(self);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame]){
        UITableViewCommonInit(self);
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // init From Nib must call this after `initWithCoder:` and i don't know why
    UITableViewCommonInit(self);
}

- (void)setTableHeaderView:(UIView *)tableHeaderView
{
    _tableHeaderView = tableHeaderView;
    if (tableHeaderView){
        CGFloat height = CGRectGetHeight(tableHeaderView.frame);
        self.inner_outlineView.headerView = nil;
        NSTableHeaderView *headerView = [[NSTableHeaderView alloc] init];
        [headerView setFrame:NSMakeRect(0, 0, self.bounds.size.width, height)];
        self.inner_outlineView.headerView = headerView;
        [tableHeaderView setFrame:NSMakeRect(0, 0, self.bounds.size.width, height)];
        [tableHeaderView setAutoresizingMask:NSViewWidthSizable];
        [self.inner_outlineView.headerView addSubview:tableHeaderView];
    }else{
        NSEdgeInsets originInsets = self.contentInsets;
        [self setContentInsets:NSEdgeInsetsMake(0, originInsets.left, originInsets.bottom, originInsets.right)];
    }
}

- (void)setTableFooterView:(UIView *)tableFooterView
{
    _tableFooterView = tableFooterView;
    if (tableFooterView){
        CGFloat height = CGRectGetHeight(tableFooterView.frame);
        NSEdgeInsets originInsets = self.contentInsets;
        [self setContentInsets:NSEdgeInsetsMake(originInsets.top, originInsets.left, height, originInsets.right)];
        [self.contentView addSubview:tableFooterView];
        
        [tableFooterView setFrame:NSMakeRect(0, 0, self.bounds.size.width, tableFooterView.bounds.size.height)];
        [tableFooterView setAutoresizingMask:NSViewWidthSizable];
    }else{
        NSEdgeInsets originInsets = self.contentInsets;
        [self setContentInsets:NSEdgeInsetsMake(originInsets.top, originInsets.left, 0, originInsets.right)];
    }
}

- (void)setDataSource:(id<UITableViewDataSource>)newSource
{
    _dataSource = newSource;
    
    _dataSourceHas.numberOfSectionsInTableView = [_dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)];
    _dataSourceHas.titleForHeaderInSection = [_dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)];
    _dataSourceHas.titleForFooterInSection = [_dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)];
    _dataSourceHas.commitEditingStyle = [_dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)];
    _dataSourceHas.canEditRowAtIndexPath = [_dataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)];
    
    [self reloadData];
}

- (void)setDelegate:(id<UITableViewDelegate>)newDelegate
{
    [super setDelegate:newDelegate];
    
    _delegateHas.heightForRowAtIndexPath = [newDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)];
    _delegateHas.heightForHeaderInSection = [newDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)];
    _delegateHas.heightForFooterInSection = [newDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)];
    _delegateHas.viewForHeaderInSection = [newDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)];
    _delegateHas.viewForFooterInSection = [newDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)];
    _delegateHas.willSelectRowAtIndexPath = [newDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)];
    _delegateHas.didSelectRowAtIndexPath = [newDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)];
    _delegateHas.willDeselectRowAtIndexPath = [newDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)];
    _delegateHas.didDeselectRowAtIndexPath = [newDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)];
    _delegateHas.willBeginEditingRowAtIndexPath = [newDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)];
    _delegateHas.didEndEditingRowAtIndexPath = [newDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)];
    _delegateHas.titleForDeleteConfirmationButtonForRowAtIndexPath = [newDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)];
}

- (void)reloadData
{
    [self.inner_outlineView resizeSubviewsWithOldSize:self.bounds.size];
    [self.inner_outlineView resizeWithOldSuperviewSize:self.bounds.size];
    [self p_reloadData];
    [self.inner_outlineView reloadData];
//    for (int i = 0; i < self.numberOfSections; i++){
//        [self.inner_outlineView expandItem:@(i) expandChildren:YES];
//    }
    [self.inner_outlineView expandItem:nil expandChildren:YES];
}

- (void)registerNib:(nullable NSNib *)nib forCellReuseIdentifier:(NSString *)identifier
{
    [self.inner_outlineView registerNib:nib forIdentifier:identifier];
}

- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    
}

- (void)registerNib:(nullable NSNib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)identifier
{
    
}

- (void)registerClass:(nullable Class)aClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier
{
    
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableDictionary *indexsMap = [NSMutableDictionary dictionary];
    for (NSIndexPath *indexPath in indexPaths){
        NSNumber *sectionKey = @(indexPath.section);
        NSMutableArray *section = [indexsMap objectForKey:sectionKey];
        if (section){
            [section addObject:@(indexPath.row)];
        }else{
            section = [NSMutableArray array];
            [section addObject:@(indexPath.row)];
            [indexsMap setObject:section forKey:sectionKey];
        }
    }
    for (NSNumber *key in indexsMap) {
        NSMutableArray *sectionArray = [indexsMap objectForKey:key];
        NSMutableIndexSet *indexesOfObjects = [NSMutableIndexSet indexSet];
        for (NSNumber *index in sectionArray) {
            if ([index isKindOfClass:NSNumber.class] && [index integerValue] != NSNotFound){
                [indexesOfObjects addIndex:[index integerValue]];
            }
        }
        [self.inner_outlineView removeItemsAtIndexes:indexesOfObjects inParent:key withAnimation:NSTableViewAnimationEffectFade];
    }
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > [self numberOfRowsInSection:indexPath.section]){
        return nil;
    }
    NSInteger row = [self indexPathIntoRow:indexPath];
    if (row > [self.inner_outlineView numberOfRows]){
        return nil;
    }
    return [self.inner_outlineView viewAtColumn:0 row:[self indexPathIntoRow:indexPath] makeIfNecessary:YES];
}

- (void)p_reloadData
{
    [self.cacheCells removeAllObjects];
    self.numberOfSections = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]){
        self.numberOfSections = [self.dataSource numberOfSectionsInTableView:self];
    }
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    return [self.inner_outlineView makeViewWithIdentifier:identifier owner:nil];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]){
        return [self.dataSource tableView:self numberOfRowsInSection:section];
    }
    return 0;
}

#pragma mark - Menu
static NSInteger kUITableViewDeleteTag = 10240;
- (void)menuNeedsUpdate:(NSMenu *)menu
{
    [self.rightMenu removeAllItems];
    if (self.inner_outlineView.clickedRow == -1 && self.inner_outlineView.selectedRow == -1){
        return;
    }
    
    id obj = [self.inner_outlineView itemAtRow:self.inner_outlineView.selectedRow];
    if (![obj isKindOfClass:UITableViewCell.class]){
        obj = [self.inner_outlineView itemAtRow:self.inner_outlineView.clickedRow];
        if (![obj isKindOfClass:UITableViewCell.class]){
            return;
        }
    }
    
    NSIndexPath *indexPath = [self out_selectedIndexPath];
    if (!indexPath){
        indexPath = [self out_clickedIndexPath];
    }
    if ([self.dataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]){
        if ([self.dataSource tableView:self canEditRowAtIndexPath:indexPath]){
            if ([self.delegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]){
                NSArray *rowActions = [self.delegate tableView:self editActionsForRowAtIndexPath:indexPath];
                for (int i = 0; i < rowActions.count; i++){
                    UITableViewRowAction *action = rowActions[i];
                    if ([action isKindOfClass:UITableViewRowAction.class]){
                        NSMenuItem *actionItem = [[NSMenuItem alloc] initWithTitle:action.title action:@selector(mnuActionRowSelected:) keyEquivalent:@""];
                        actionItem.representedObject = indexPath;
                        [self.rightMenu addItem:actionItem];
                    }
                }
                if (self.rightMenu.itemArray.count > 0){
                    return;
                }
            }
            
            NSString *deleteString = NSLocalizedString(@"Delete", @"Delete");
            if ([self.delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]){
                deleteString = [self.delegate tableView:self titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
            }
            NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Delete", @"Delete") action:@selector(mnuDeleteRowSelected:) keyEquivalent:@""];
            deleteItem.tag = kUITableViewDeleteTag;
            [self.rightMenu addItem:deleteItem];
        }
    }
}

- (void)mnuDeleteRowSelected:(NSMenuItem *)sender
{
    if ([self.dataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]){
        NSIndexPath *indexPath = [self out_selectedIndexPath];
        if (!indexPath){
            indexPath = [self out_clickedIndexPath];
        }
        [self.dataSource tableView:self commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }
}

- (void)mnuActionRowSelected:(NSMenuItem *)sender
{
    if ([sender.representedObject isKindOfClass:NSIndexPath.class]){
        NSIndexPath *indexPath = sender.representedObject;
        if ([self.delegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]){
            NSArray *rowActions = [self.delegate tableView:self editActionsForRowAtIndexPath:indexPath];
            for (int i = 0; i < rowActions.count; i++){
                UITableViewRowAction *action = rowActions[i];
                if ([action isKindOfClass:UITableViewRowAction.class] && [action.title isEqualToString:sender.title]){
                    action.handlerBlock(action, indexPath);
                    break;
                }
            }
        }
    }
}

#pragma mark - NSOutlineView Delegate

- (nullable NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(nullable NSTableColumn *)tableColumn item:(id)item
{
    if ([item isKindOfClass:UITableViewCell.class]){
        if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]){
            [self.delegate tableView:self willDisplayCell:item forRowAtIndexPath:[(UITableViewCell *)item p_indexPath]];
        }
        return item;
    }
    if ([item isKindOfClass:NSNumber.class]){
        if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]){
            UIView *headerView = [self.delegate tableView:self viewForHeaderInSection:[item integerValue]];
            if (headerView){
                return headerView;
            }
        }
    }
    return nil;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
    if ([item isKindOfClass:[NSNumber class]]){
        if ([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]){
            return [self.delegate tableView:self heightForHeaderInSection:[item integerValue]];
        }
        if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]){
            UIView *headerView = [self.delegate tableView:self viewForHeaderInSection:[item integerValue]];
            if (headerView){
                return headerView.bounds.size.height;
            }
        }
        return 0.001;
    }
    if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]){
        NSIndexPath *indexPath;
        if ([item isKindOfClass:UITableViewCell.class]){
            indexPath = [(UITableViewCell *)item p_indexPath];
        }else{
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        return [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    }
    return self.rowHeight;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item isKindOfClass:[NSNumber class]]){
        return YES;
    }
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    if ([item isKindOfClass:[NSNumber class]]){
        return YES;
    }
    return NO;
}

#pragma mark - NSOutlineView DataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(nullable id)item
{
    if (!item){
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]){
            self.numberOfSections = [self.dataSource numberOfSectionsInTableView:self];
        }
        return self.numberOfSections;
    }
    if ([item isKindOfClass:[NSNumber class]]){
        if ([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]){
            return [self.dataSource tableView:self numberOfRowsInSection:[item integerValue]];
        }
    }
    return 1;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(nullable id)item
{
    if (!item){
        self.numberOfSections = 1;
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]){
            self.numberOfSections = [self.dataSource numberOfSectionsInTableView:self];
        }
        [self.cacheIndexs setObject:@(index) forKey:@(index)];
        return @(index);
    }
    if ([self.dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:[item integerValue]];
        UITableViewCell *cell = [self.dataSource tableView:self cellForRowAtIndexPath:indexPath];
        cell.p_indexPath = indexPath;
        NSDictionary *dict = @{@"section":item,@"row":@(index)};
        [self.cacheCells setObject:cell forKey:dict];
        return cell;
    }
    return nil;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSIndexPath *indexPath = [self out_selectedIndexPath];
    if (!indexPath){
        return;
    }
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:UITableViewCell.class]){
        if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            [self.delegate tableView:self didSelectRowAtIndexPath:indexPath];
        }
        [self.inner_outlineView deselectRow:self.inner_outlineView.selectedRow];
        if ([self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]){
            [self.delegate tableView:self didDeselectRowAtIndexPath:indexPath];
        }
    }
}

#pragma mark - Select Cell
// Use for inner NSOutlineView
- (NSIndexPath * _Nullable)p_selectedIndexPath
{
    NSInteger row = self.inner_outlineView.selectedRow;
    if (row < 0){
        return nil;
    }
    
    NSInteger pendingRowCount = 1; // 从1开始，因为有section
    for (int i = 0; i < self.numberOfSections; i++){
        NSInteger thisRowCount = [self outlineView:self.inner_outlineView numberOfChildrenOfItem:@(i)];
        if (row > thisRowCount + pendingRowCount){
            pendingRowCount += thisRowCount;
        }else{
            return [NSIndexPath indexPathForRow:row inSection:i];
        }
    }
    return nil;
}

- (NSIndexPath * _Nullable)p_clickedIndexPath
{
    NSInteger row = self.inner_outlineView.clickedRow;
    if (row < 0){
        return nil;
    }
    
    NSInteger pendingRowCount = 1; // 从1开始，因为有section
    for (int i = 0; i < self.numberOfSections; i++){
        NSInteger thisRowCount = [self outlineView:self.inner_outlineView numberOfChildrenOfItem:@(i)];
        if (row > thisRowCount + pendingRowCount){
            pendingRowCount += thisRowCount;
        }else{
            return [NSIndexPath indexPathForRow:row inSection:i];
        }
    }
    return nil;
}

- (NSIndexPath * _Nullable)out_selectedIndexPath
{
    NSInteger row = self.inner_outlineView.selectedRow;
    if (row < 0){
        return nil;
    }
    NSInteger pendingRowCount = 0;
    for (int i = 0; i < self.numberOfSections; i++){
        NSInteger thisRowCount = [self outlineView:self.inner_outlineView numberOfChildrenOfItem:@(i)];
        if (row > thisRowCount + pendingRowCount){
            pendingRowCount += thisRowCount;
            pendingRowCount ++;
        }else{
            if (row == 0 && pendingRowCount == 0){
                return nil;
            }
            NSInteger decideRow = row - pendingRowCount - 1;
            if (decideRow < 0 || decideRow == NSNotFound){
                return nil;
            }
            return [NSIndexPath indexPathForRow:decideRow inSection:i];
        }
    }
    return nil;
}

- (NSIndexPath * _Nullable)out_clickedIndexPath
{
    NSInteger row = self.inner_outlineView.clickedRow;
    if (row < 0){
        return nil;
    }
    NSInteger pendingRowCount = 0;
    for (int i = 0; i < self.numberOfSections; i++){
        NSInteger thisRowCount = [self outlineView:self.inner_outlineView numberOfChildrenOfItem:@(i)];
        if (row > thisRowCount + pendingRowCount){
            pendingRowCount += thisRowCount;
            pendingRowCount ++;
        }else{
            return [NSIndexPath indexPathForRow:row - pendingRowCount - 1 inSection:i];
        }
    }
    return nil;
}

- (NSInteger)indexPathIntoRow:(NSIndexPath *)indexPath
{
    NSInteger pendingRowCount = 0;
    NSInteger section = [indexPath section];
    if (section > self.numberOfSections){
        return 0;
    }
    for (int i = 0; i <= section; i++){
        NSInteger thisRowCount = [self outlineView:self.inner_outlineView numberOfChildrenOfItem:@(i)];
        if (i == section){
            pendingRowCount = pendingRowCount + indexPath.row + section + 1;
            break;
        }else{
            pendingRowCount = pendingRowCount + thisRowCount;
        }
    }
    return pendingRowCount;
}
@end

@implementation UIRefreshControl
- (void)beginRefreshing
{
    
}

- (void)endRefreshing
{
    
}

@end

@implementation UITableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super init]){
        UITableViewControllerCommonInit(self);
    }
    return self;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]){
        
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]){
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITableViewControllerCommonInit(self);
}

static void UITableViewControllerCommonInit(UITableViewController *tableViewController) {
    
    if (tableViewController.tableView.dataSource == tableViewController && tableViewController.tableView.delegate == tableViewController){
        return;
    }
    
    if (!tableViewController.tableView){
        tableViewController.tableView = [[UITableView alloc] initWithFrame:tableViewController.view.bounds];
        [tableViewController.view addSubview:tableViewController.tableView];
    }
    
    tableViewController.tableView.delegate = tableViewController;
    tableViewController.tableView.dataSource = tableViewController;
    tableViewController.tableView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
}

@end


@implementation NSIndexPath (UITableView)
+ (NSIndexPath *)indexPathForRow:(NSUInteger)row inSection:(NSUInteger)section
{
    NSUInteger path[2] = {section, row};
    return [self indexPathWithIndexes:path length:2];
}

- (NSUInteger)row
{
    return [self indexAtPosition:1];
}

-(NSUInteger)section
{
    return [self indexAtPosition:0];
}

@end
