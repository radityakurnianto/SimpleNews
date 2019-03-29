//
//  Extension+UICollectionView.swift
//  RWGenericReusable
//
//  Created by Raditya Kurnianto on 1/10/19.
//

import UIKit

public extension UICollectionView {
    func register<T: UICollectionViewCell>(cell _: T.Type) where T: RWGenericReusable {
        if let nib = T.nib {
            self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: RWGenericReusable {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
