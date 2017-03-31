//
//  PJProductDecorationView.m
//  PJ
//
//  Created by WeiHu on 2017/3/27.
//  Copyright © 2017年 dj0708. All rights reserved.
//

#import "PJProductDecorationView.h"

@implementation PJProductDecorationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    //    NSLog(@"%s", __func__);
    
    _imageView.frame = self.bounds;
    
}
@end
