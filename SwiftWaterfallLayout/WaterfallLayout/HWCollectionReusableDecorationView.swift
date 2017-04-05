//
//  HWCollectionReusableDecorationView.swift
//  UICollectionViewLayoutDemoSwift
//
//  Created by WeiHu on 2017/4/1.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

import UIKit

class HWCollectionReusableDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
