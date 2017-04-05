//
//  ViewController.swift
//  UICollectionViewLayoutDemoSwift
//
//  Created by WeiHu on 2017/4/1.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct Identfier {
        static let header: String = "header"
        static let footer: String = "footer"
        static let cell: String = "cell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view .addSubview(colletionView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var colletionView:UICollectionView = {[unowned self] in
        let colletionView: UICollectionView = UICollectionView(frame:self.view.bounds, collectionViewLayout:self.layout)
        colletionView.dataSource = self;
        colletionView.delegate = self
        colletionView.translatesAutoresizingMaskIntoConstraints = false;
        colletionView.backgroundColor = .white
        colletionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Identfier.cell)
        let headerView = UIView()
        headerView.backgroundColor = UIColor.red
        headerView.frame = CGRect(x: 0,y: 0,width: 375, height: 50)
        colletionView.hw_collectionHeaderView = headerView
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor.green
        footerView.frame = CGRect(x: 0,y: 0,width: 375, height: 50)
        colletionView.hw_collectionFooterView = footerView
        
        colletionView.register(HWCollectionReusableHeaderView.self, forSupplementaryViewOfKind: HWCollectionElementKindSection.header, withReuseIdentifier: Identfier.header)
        colletionView.register(HWCollectionReusableFooterView.self, forSupplementaryViewOfKind: HWCollectionElementKindSection.footer, withReuseIdentifier: Identfier.footer)
        return colletionView
        }()
    
    lazy var layout:HWCollectionViewWaterfallLayout = {[unowned self] in
        let layout = HWCollectionViewWaterfallLayout()
        layout.itemInsets = UIEdgeInsetsMake(0, 0, 1, 0);
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width,height: 90.0);
        layout.headerHeight = 150;
        layout.footerHeight = 100;
        return layout;
        }()
}
extension ViewController: HWCollectionViewWaterfallLayoutDelegate{
    
}
extension ViewController: UICollectionViewDataSource{
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return 4;
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 3
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: Identfier.cell, for: indexPath)
        cell.backgroundColor = .orange
        return cell;
    }
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        if kind == HWCollectionElementKindSection.header{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identfier.header, for: indexPath    )
            return headerView;
        }else if kind == HWCollectionElementKindSection.footer{
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identfier.footer, for: indexPath    )
            return footerView;
        }
        return UICollectionReusableView()
    }
}
extension ViewController: UICollectionViewDelegate{
    
}
