//
//  PJProductCollectionViewCell.h
//  Demo9
//
//  Created by WeiHu on 2017/3/27.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTapBlock)(NSObject *modelObject);

@interface PJProductCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSObject *modelObject;
@property (nonatomic, copy) ClickTapBlock clickTapBlock;
@end
