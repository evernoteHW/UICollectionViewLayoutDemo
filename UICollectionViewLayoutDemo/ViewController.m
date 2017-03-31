//
//  ViewController.m
//  DecordviewCollectionViewDemo
//
//  Created by WeiHu on 2017/3/30.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

#import "ViewController.h"
#import "HWCollectionViewWaterfallLayout.h"
#import "PJCollectionReusableHeaderView.h"
#import "PJCollectionReusableFooterView.h"
#import "MJRefresh.h"
#import "DemoView.h"

static NSString * const PhotoCellIdentifier = @"PhotoCell";
static NSString * const PhotoHeaderIdentifier = @"PhotoHeaderIdentifier";
static NSString * const PhotoFooterIdentifier = @"PhotoFooterIdentifier";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate,HWCollectionViewWaterfallLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    // Do any additional setup after loading the view, typically from a nib.
    HWCollectionViewWaterfallLayout *layout = [[HWCollectionViewWaterfallLayout alloc] init];
    layout.layoutDelegate = self;
    layout.itemInsets = UIEdgeInsetsMake(0, 0, 1, 0);
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 90.0);
    //    layout.headerHeight = 100;
    //    layout.footerHeight = 100;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    DemoView *button = [DemoView buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(0, 0, 375, 100);
    [button addTarget:self action:@selector(ddd) forControlEvents:UIControlEventTouchUpInside];
    self.collectionView.hw_collectionHeaderView = button;
    
    
    DemoView *footerView = [DemoView buttonWithType:UIButtonTypeCustom];
    footerView.backgroundColor = [UIColor greenColor];
    footerView.frame = CGRectMake(0, 0, 375, 100);
    [footerView addTarget:self action:@selector(ddd) forControlEvents:UIControlEventTouchUpInside];
    self.collectionView.hw_collectionFooterView = footerView;
    
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:PhotoCellIdentifier];
    [self.collectionView registerClass:[PJCollectionReusableHeaderView class] forSupplementaryViewOfKind:HWCollectionElementKindSectionHeader withReuseIdentifier:PhotoHeaderIdentifier];
    [self.collectionView registerClass:[PJCollectionReusableFooterView class] forSupplementaryViewOfKind:HWCollectionElementKindSectionFooter withReuseIdentifier:PhotoFooterIdentifier];
    
    [self.view addSubview:self.collectionView];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        DemoView *button = [DemoView buttonWithType:UIButtonTypeCustom];
    //        button.backgroundColor = [UIColor yellowColor];
    //        button.frame = CGRectMake(0, 0, 375, 200);
    //        [button addTarget:self action:@selector(ddd) forControlEvents:UIControlEventTouchUpInside];
    //        self.collectionView.pjCollectionHeaderView = button;
    //    });
    //
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        DemoView *button = [DemoView buttonWithType:UIButtonTypeCustom];
    //        button.backgroundColor = [UIColor orangeColor];
    //        button.frame = CGRectMake(0, 0, 375, 200);
    //        [button addTarget:self action:@selector(ddd) forControlEvents:UIControlEventTouchUpInside];
    //        self.collectionView.pjCollectionFooterView = button;
    //    });
    
    __weak ViewController *weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ViewController *strongSelf = weakSelf;
            [strongSelf.collectionView.mj_header endRefreshing];
        });
    }];
    
    //    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            ViewController *strongSelf = weakSelf;
    ////            strongSelf.collectionView.mj_footer.hidden = YES;
    //            [strongSelf.collectionView.mj_footer endRefreshing];
    //        });
    //    }];
}
- (void)ddd{
    NSLog(@"...");
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *photoCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                              forIndexPath:indexPath];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 40)];
    view.backgroundColor = [UIColor yellowColor];
    photoCell.selectedBackgroundView = view;
    photoCell.backgroundColor = [UIColor orangeColor];
    return photoCell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == HWCollectionElementKindSectionHeader) {
        
        PJCollectionReusableHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PhotoHeaderIdentifier forIndexPath:indexPath];
        return headerView;
    }else if (kind == HWCollectionElementKindSectionFooter){
        PJCollectionReusableFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PhotoFooterIdentifier forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.highlighted = NO;
    NSLog(@"%d....%d",cell.highlighted,cell.isSelected);
}
#pragma mark - HWCollectionViewWaterfallLayoutDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HWCollectionViewWaterfallLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(HWCollectionViewWaterfallLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
