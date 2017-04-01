//
//  HWCollectionReusableHeaderView.swift
//  UICollectionViewLayoutDemoSwift
//
//  Created by WeiHu on 2017/4/1.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

import UIKit

class HWCollectionReusableHeaderView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
