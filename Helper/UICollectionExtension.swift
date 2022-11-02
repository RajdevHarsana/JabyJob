//
//  UICollectionExtension.swift
//  JabyJob
//
//  Created by Arkamac1 on 12/01/22.
//

import Foundation
import UIKit
class CollectionViewRow {
    
    var attributes = [UICollectionViewLayoutAttributes]()
    var spacing: CGFloat = 0
    
    init(spacing: CGFloat) {
        self.spacing = spacing
    }

    func add(attribute: UICollectionViewLayoutAttributes) {
        attributes.append(attribute)
    }

    var rowWidth: CGFloat {
        
        
        return attributes.reduce(0, { result, attribute -> CGFloat in
            return result + attribute.frame.width
        }) + CGFloat(attributes.count - 1) * spacing
    }

    func layout(collectionViewWidth: CGFloat) {
         
        var offset = spacing
        for attribute in attributes {
//            attribute.frame.size.height = 100
            attribute.frame.origin.x = offset
            offset += attribute.bounds.width + spacing
        }
    }
}
class UICollectionViewCenterLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var rows = [CollectionViewRow]()
        var currentRowY: CGFloat = -1

        for attribute in attributes {
            if currentRowY != attribute.frame.midY {
                currentRowY = attribute.frame.midY
                rows.append(CollectionViewRow(spacing: 10))
            }
            rows.last?.add(attribute: attribute)
            
        }

        rows.forEach { $0.layout(collectionViewWidth: collectionView?.frame.width ?? 0) }
        return rows.flatMap { $0.attributes }
    }
}
