//
//  PJCollectionReusableFooterView.h
//  Demo9
//
//  Created by WeiHu on 2017/3/27.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommonBottomView;
@interface PJCollectionReusableFooterView : UICollectionReusableView
@property (nonatomic, strong) NSObject *modelObject;
@property (nonatomic, strong) CommonBottomView *bottomView;
@end
