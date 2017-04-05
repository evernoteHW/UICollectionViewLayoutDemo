//
//  HWCollectionViewWaterfallLayout.swift
//  UICollectionViewLayoutDemoSwift
//
//  Created by WeiHu on 2017/4/1.
//  Copyright © 2017年 WeiHu. All rights reserved.
//

import UIKit

struct HWCollectionElementKindSection {
    static let header: String = "HWCollectionElementKindSectionHeader"
    static let footer: String = "HWCollectionElementKindSectionFooter"
    static let decoration: String = "HWCollectionElementKindSectionDecoration"
}

struct HWLayoutKind {
    static let cell: String = "HWLayoutKind.cell"
    static let header: String = "HWLayoutKind.header"
    static let footer: String = "HWLayoutKind.footer"
    static let decoration: String = "HWLayoutKind.decoration"
}

@objc protocol HWCollectionViewWaterfallLayoutDelegate: class {
    //item size
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: HWCollectionViewWaterfallLayout,sizeForItemAtIndexPath: IndexPath) -> CGSize
    //Footer Insets
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: HWCollectionViewWaterfallLayout,insetForFooterSectionAtIndex: IndexPath) -> UIEdgeInsets
    //Header Insets
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: HWCollectionViewWaterfallLayout,insetForHeaderSectionAtIndex: IndexPath) -> UIEdgeInsets
    //item Insets
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: HWCollectionViewWaterfallLayout,insetForItemAtIndexPath: IndexPath) -> UIEdgeInsets
    //decoration Insets
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: HWCollectionViewWaterfallLayout,insetForDecorationSectionAtIndex: IndexPath) -> UIEdgeInsets
    //header height
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: HWCollectionViewWaterfallLayout,referenceSizeForHeaderInSection: IndexPath) -> Float
    //footer height
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: HWCollectionViewWaterfallLayout,referenceSizeForFooterInSection: IndexPath) -> Float
}
//Propertys
class HWCollectionViewWaterfallLayout: UICollectionViewLayout {
    var itemInsets: UIEdgeInsets = .zero
    var headerInsets: UIEdgeInsets = .zero
    var footerInsets: UIEdgeInsets = .zero
    var decorationInsets: UIEdgeInsets = .zero
    private var layoutInfo: [String : [IndexPath: UICollectionViewLayoutAttributes]]?
    
    var itemSize: CGSize = .zero
    var headerHeight: Float = 0.0
    var footerHeight: Float = 0.0
    weak var layoutDelegate: HWCollectionViewWaterfallLayoutDelegate?
    override init() {
        super.init()
        self.register(HWCollectionReusableDecorationView.self, forDecorationViewOfKind: HWCollectionElementKindSection.decoration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
        
        var newLayoutInfo: [String : [IndexPath: UICollectionViewLayoutAttributes]] = [String : [IndexPath: UICollectionViewLayoutAttributes]]()
        var cellLayoutInfo: [IndexPath: UICollectionViewLayoutAttributes] = [IndexPath: UICollectionViewLayoutAttributes]()
        var headerLayoutInfo: [IndexPath: UICollectionViewLayoutAttributes] = [IndexPath: UICollectionViewLayoutAttributes]()
        var footerLayoutInfo: [IndexPath: UICollectionViewLayoutAttributes] = [IndexPath: UICollectionViewLayoutAttributes]()
        var decorationLayoutInfo: [IndexPath: UICollectionViewLayoutAttributes] = [IndexPath: UICollectionViewLayoutAttributes]()
        
        guard let collectionView = self.collectionView else { return }
        let sectionCount = collectionView.numberOfSections
        var top: Float = 0.0;
        //CollectionHeaderView
        if let hw_collectionHeaderView = collectionView.hw_collectionHeaderView{
            top += Float(hw_collectionHeaderView.frame.height)
        }
    
        for section in 0..<sectionCount {
            //Header
            
            let headerIndexPath: IndexPath = IndexPath(row: 0,section: section)
           
            let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: HWCollectionElementKindSection.header, with: headerIndexPath)
            var headerHeight: Float = self.headerHeight;
            
            if let layoutDelegate = self.layoutDelegate, let method = layoutDelegate.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: headerIndexPath){
               headerHeight = method
            }
            headerAttributes.frame = CGRect(x: 0, y: CGFloat(top), width: collectionView.frame.width,height: CGFloat(headerHeight));
            headerLayoutInfo[headerIndexPath] = headerAttributes;
            top += headerHeight;
            
            //item set up
            var itemHeight: Float = 0.0
            let itemCount: Int = collectionView.numberOfItems(inSection: section)
            for row in 0..<itemCount {
                let indexPath: IndexPath = IndexPath(row: row,section: section)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
                //itemSize
                var itemSize: CGSize = self.itemSize;
                if let layoutDelegate = self.layoutDelegate, let method = layoutDelegate.collectionView?(collectionView, layout: self, sizeForItemAtIndexPath: indexPath){
                    itemSize = method
                }
                
                //itemInsets
                var itemInsets: UIEdgeInsets = self.itemInsets;
                if let layoutDelegate = self.layoutDelegate, let method = layoutDelegate.collectionView?(collectionView, layout: self, insetForItemAtIndexPath: indexPath){
                    itemInsets = method
                }
                
                //item frame
                let item_x: Float = Float(itemInsets.left)
                let item_y: Float = top + itemHeight + Float(itemInsets.top)
                let item_width: Float = Float(itemSize.width - itemInsets.left - itemInsets.right)
                let item_height: Float = Float(itemSize.height - itemInsets.top - itemInsets.bottom)
                
                itemAttributes.frame = CGRect(x: CGFloat(item_x),y: CGFloat(item_y),width: CGFloat(item_width),height: CGFloat(item_height));
                cellLayoutInfo[indexPath] = itemAttributes
                
                itemHeight += Float(itemSize.height)
            }
             top += itemHeight
         
            //Footer frame
            let footerIndexPath = IndexPath(row: itemCount - 1, section: section)
            let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: HWCollectionElementKindSection.footer,with: footerIndexPath)
            var footerHeight: Float = self.footerHeight
            
            if let layoutDelegate = self.layoutDelegate, let method = layoutDelegate.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: footerIndexPath){
                footerHeight = method
            }
            
            footerAttributes.frame = CGRect(x: CGFloat(0),y: CGFloat(top),width: collectionView.frame.width,height: CGFloat(footerHeight));
            footerLayoutInfo[footerIndexPath] = footerAttributes;
            top += footerHeight;
            
            //Decoration frame
            var decorationInsets = self.decorationInsets;
            if let layoutDelegate = self.layoutDelegate, let method = layoutDelegate.collectionView?(collectionView, layout: self, insetForDecorationSectionAtIndex: footerIndexPath){
                decorationInsets = method
            }
            let decorationIndexPath: IndexPath = IndexPath(row:0, section: section)
            
            let decorationAttributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: HWCollectionElementKindSection.decoration, with: decorationIndexPath)
            
            let decorationHeight = footerAttributes.frame.maxY - headerAttributes.frame.minY;
            
            decorationAttributes.frame = CGRect(x: decorationInsets.left, y: headerAttributes.frame.minY + decorationInsets.top,width: collectionView.frame.width - decorationInsets.left - decorationInsets.right, height: decorationHeight - decorationInsets.top - decorationInsets.bottom);
            decorationAttributes.zIndex = -1;
            decorationLayoutInfo[decorationIndexPath] = decorationAttributes;

            
        }
        
        //CollectionFooterView
        if let hw_collectionFooterView = collectionView.hw_collectionFooterView {
            hw_collectionFooterView.frame = CGRect(x: hw_collectionFooterView.frame.origin.x,y: CGFloat(top) ,width: hw_collectionFooterView.frame.size.width,height: hw_collectionFooterView.frame.size.height)
            ;
            top += Float(hw_collectionFooterView.bounds.height)
        }
        
        newLayoutInfo[HWLayoutKind.cell] = cellLayoutInfo;
        newLayoutInfo[HWLayoutKind.header] = headerLayoutInfo;
        newLayoutInfo[HWLayoutKind.footer] = footerLayoutInfo;
        newLayoutInfo[HWLayoutKind.decoration] = decorationLayoutInfo;
        
        self.layoutInfo = newLayoutInfo;
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutInfo = self.self.layoutInfo else { return super.layoutAttributesForElements(in: rect)}
        
        var allAttributes = [UICollectionViewLayoutAttributes]()

        layoutInfo.forEach { (_, elementsInfo) in
            
            elementsInfo.forEach({ (_,attributes) in
                if rect.intersects(attributes.frame) {
                    allAttributes.append(attributes)
                }
            })
            
        }
        return allAttributes;
    }
    override var collectionViewContentSize: CGSize{
    
        guard let collectionView = self.collectionView else { return super.collectionViewContentSize}
        let sectionCount: Int = collectionView.numberOfSections
        if (sectionCount <= 0) { return super.collectionViewContentSize}
        let numberOfItemsInSection: Int = collectionView.numberOfItems(inSection: sectionCount - 1)
    
        guard let layoutInfo = self.self.layoutInfo else { return super.collectionViewContentSize}
        let dic = layoutInfo[HWLayoutKind.footer]
        
        let lastAttributes: UICollectionViewLayoutAttributes = dic![IndexPath(row: numberOfItemsInSection - 1, section: sectionCount - 1)]!
        
        var height = lastAttributes.frame.maxY;
        if let hw_collectionFooterView = collectionView.hw_collectionFooterView {
            height += hw_collectionFooterView.frame.height;
        }
        return CGSize(width: collectionView.bounds.size.width,height: height);
        
        
    }
    
}

extension UICollectionView{
    private struct AssociatedKeys {
        static var header = "UICollectionView.Header"
        static var footer = "UICollectionView.Footer"
    }
    
    var hw_collectionHeaderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.header) as? UIView
        }
        set (headerView) {
            guard let headerView = headerView else { return }
            self.hw_collectionHeaderView?.removeFromSuperview()
            objc_setAssociatedObject(self, &AssociatedKeys.header, headerView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.addSubview(headerView)
        }
    }
    var hw_collectionFooterView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.footer) as? UIView
        }
        set (footerView) {
            guard let footerView = footerView else { return }
            self.hw_collectionFooterView?.removeFromSuperview()
            objc_setAssociatedObject(self, &AssociatedKeys.footer, footerView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.addSubview(footerView)
        }
    }
}
