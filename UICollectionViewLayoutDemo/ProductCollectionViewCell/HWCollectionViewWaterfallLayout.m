//
//  UIView+FourCornerRadius.m
//  hw
//
//  Created by WeiHu on 2017/2/27.
//  Copyright © 2017年 dj0708. All rights reserved.
//


#import "HWCollectionViewWaterfallLayout.h"
#import "PJProductDecorationView.h"
#import <objc/runtime.h>

NSString *const HWCollectionElementKindSectionHeader = @"HWCollectionElementKindSectionHeader";
NSString *const HWCollectionElementKindSectionFooter = @"HWCollectionElementKindSectionFooter";
NSString *const HWCollectionElementKindSectionDecoration = @"HWCollectionElementKindSectionDecoration";

static NSString * const HWLayoutItemCellKind = @"HWLayoutItemCellKind";
static NSString * const HWLayoutHeaderKind = @"HWLayoutHeaderKind";
static NSString * const HWLayoutFooterKind = @"HWLayoutFooterKind";
static NSString * const HWLayoutDecorationKind = @"HWLayoutDecorationKind";


@implementation UICollectionView (HeaderViewAndFooterView)

- (UIView *)hw_collectionHeaderView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHw_collectionHeaderView:(UIView *)hw_collectionHeaderView
{
    [self.hw_collectionHeaderView removeFromSuperview];
    objc_setAssociatedObject(self, @selector(hw_collectionHeaderView), hw_collectionHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addSubview:hw_collectionHeaderView];
    [self.collectionViewLayout invalidateLayout];
    
}
- (UIView *)hw_collectionFooterView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHw_collectionFooterView:(UIView *)hw_collectionFooterView
{
    [self.hw_collectionFooterView removeFromSuperview];
    objc_setAssociatedObject(self, @selector(hw_collectionFooterView), hw_collectionFooterView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addSubview:hw_collectionFooterView];
    [self.collectionViewLayout invalidateLayout];
}

@end


@interface HWCollectionViewWaterfallLayout ()
@property (nonatomic, strong) NSDictionary *layoutInfo;

@end

@implementation HWCollectionViewWaterfallLayout

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    [self registerClass:[PJProductDecorationView class] forDecorationViewOfKind:HWCollectionElementKindSectionDecoration];
    
    self.itemInsets = UIEdgeInsetsZero;
    self.itemSize = CGSizeZero;
    self.headerHeight = 0;
    self.footerHeight = 0;
}

- (void)prepareLayout{
    [super prepareLayout];
    
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *footerLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *decorationLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    //CollectionHeaderView
    
    CGFloat top = 0.0;
    if (self.collectionView.hw_collectionHeaderView) {
        top += self.collectionView.hw_collectionHeaderView.bounds.size.height;
    }
    NSLog(@"%@",NSStringFromCGRect(self.collectionView.hw_collectionHeaderView.frame));
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        //Header
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:HWCollectionElementKindSectionHeader withIndexPath:headerIndexPath];
        CGFloat headerHeight = self.headerHeight;
        if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            headerHeight = [self.layoutDelegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
        }
        //header insets
        
        headerAttributes.frame = CGRectMake(0, top, CGRectGetWidth(self.collectionView.frame), headerHeight);
        headerLayoutInfo[headerIndexPath] = headerAttributes;
        top += headerHeight;
        
        //item set up
        CGFloat itemHeight = 0.0;
        for (NSInteger item = 0; item < itemCount; item++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            //itemSize
            CGSize itemSize = self.itemSize;
            if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
                itemSize = [self.layoutDelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            }
            //itemInsets
            UIEdgeInsets itemInsets = self.itemInsets;
            if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:insetForItemAtIndexPath:)]) {
                itemInsets = [self.layoutDelegate collectionView:self.collectionView layout:self insetForItemAtIndexPath:indexPath];
            }
            
            //item frame
            CGFloat item_x = itemInsets.left;
            CGFloat item_y = top + itemHeight + itemInsets.top;
            CGFloat item_width = itemSize.width - itemInsets.left - itemInsets.right;
            CGFloat item_height = itemSize.height - itemInsets.top - itemInsets.bottom;
            
            itemAttributes.frame = CGRectMake(item_x,item_y, item_width, item_height);
            cellLayoutInfo[indexPath] = itemAttributes;
            
            itemHeight += (itemSize.height);
        }
        
        top += itemHeight;
        
        //Footer frame
        NSIndexPath *footerIndexPath = [NSIndexPath indexPathForItem:itemCount - 1 inSection:section];
        UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:HWCollectionElementKindSectionFooter withIndexPath:footerIndexPath];
        
        CGFloat footerHeight = self.footerHeight;
        if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            footerHeight = [self.layoutDelegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
        }
        
        footerAttributes.frame = CGRectMake(0, top, CGRectGetWidth(self.collectionView.frame), footerHeight);
        footerLayoutInfo[footerIndexPath] = footerAttributes;
        
        top += footerHeight;
        
        UIEdgeInsets decorationInsets = self.decorationInsets;
        if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:insetForDecorationSectionAtIndex:)]) {
            decorationInsets = [self.layoutDelegate collectionView:self.collectionView layout:self insetForDecorationSectionAtIndex:section];
        }
        
        //Decoration frame
        NSIndexPath *decorationIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *decorationAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:HWCollectionElementKindSectionDecoration withIndexPath:decorationIndexPath];
        CGFloat decorationHeight = CGRectGetMaxY(footerAttributes.frame) - CGRectGetMinY(headerAttributes.frame);
        
        decorationAttributes.frame = CGRectMake(decorationInsets.left, CGRectGetMinY(headerAttributes.frame) + decorationInsets.top,CGRectGetWidth(self.collectionView.frame) - decorationInsets.left - decorationInsets.right, decorationHeight - decorationInsets.top - decorationInsets.bottom);
        decorationAttributes.zIndex = -1;
        decorationLayoutInfo[decorationIndexPath] = decorationAttributes;
        
    }
    
    //CollectionFooterView
    if (self.collectionView.hw_collectionFooterView) {
        self.collectionView.hw_collectionFooterView.frame = CGRectMake(self.collectionView.hw_collectionFooterView.frame.origin.x, top , self.collectionView.hw_collectionFooterView.frame.size.width, self.collectionView.hw_collectionFooterView.frame.size.height)
        ;
        top += self.collectionView.hw_collectionFooterView.bounds.size.height;
    }
    
    newLayoutInfo[HWLayoutItemCellKind] = cellLayoutInfo;
    newLayoutInfo[HWLayoutHeaderKind] = headerLayoutInfo;
    newLayoutInfo[HWLayoutFooterKind] = footerLayoutInfo;
    newLayoutInfo[HWLayoutDecorationKind] = decorationLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (CGSize)collectionViewContentSize
{
    NSInteger sectionCount = [self.collectionView numberOfSections];
    if (sectionCount <= 0) return [super collectionViewContentSize];
    NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:sectionCount - 1];
    
    UICollectionViewLayoutAttributes *footAttributes = nil;
    NSDictionary *dic = self.layoutInfo[HWLayoutFooterKind];
    if (dic.count > 0) {
        footAttributes = self.layoutInfo[HWLayoutFooterKind][[NSIndexPath indexPathForRow:numberOfItemsInSection - 1 inSection:sectionCount - 1]];
    }else{
        footAttributes = self.layoutInfo[HWLayoutItemCellKind][[NSIndexPath indexPathForRow:numberOfItemsInSection - 1 inSection:sectionCount - 1]];
        
    }
    CGFloat height = CGRectGetMaxY(footAttributes.frame);
    if (self.collectionView.hw_collectionFooterView) {
        height += CGRectGetHeight(self.collectionView.hw_collectionFooterView.frame);
    }
    
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}
@end
