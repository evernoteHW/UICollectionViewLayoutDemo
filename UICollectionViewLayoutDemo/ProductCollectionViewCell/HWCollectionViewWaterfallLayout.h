//
//  UIView+FourCornerRadius.h
//  hw
//
//  Created by WeiHu on 2017/2/27.
//  Copyright © 2017年 dj0708. All rights reserved.
//
#import <UIKit/UIKit.h>

extern NSString *const HWCollectionElementKindSectionHeader;
extern NSString *const HWCollectionElementKindSectionFooter;
extern NSString *const HWCollectionElementKindSectionDecoration;

@class HWCollectionViewWaterfallLayout;

@protocol HWCollectionViewWaterfallLayoutDelegate <NSObject>
@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(HWCollectionViewWaterfallLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(HWCollectionViewWaterfallLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HWCollectionViewWaterfallLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
//组与组的最小距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HWCollectionViewWaterfallLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
//组头高度
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HWCollectionViewWaterfallLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//组尾高度
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HWCollectionViewWaterfallLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
@end

#pragma mark - HWCollectionViewWaterfallLayout

@interface HWCollectionViewWaterfallLayout : UICollectionViewLayout
@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, weak) id<HWCollectionViewWaterfallLayoutDelegate> layoutDelegate;
@end



@interface UICollectionView (HeaderViewAndFooterView)
@property (nonatomic, strong) UIView *hw_collectionHeaderView;
@property (nonatomic, strong) UIView *hw_collectionFooterView;
@end
