//
//  Extension+UITableView.swift
//  RWGenericReusable
//
//  Created by Raditya Kurnianto on 1/10/19.
//

import UIKit

public extension UITableView {
    //MARK: registerCell
    func register<T: UITableViewCell>(cell _: T.Type) where T: RWGenericReusable {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueCell<T: UITableViewCell>(indexPath: IndexPath)  -> T where T: RWGenericReusable {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    //MARK: registerHeaderFooter
    func register<T: UITableViewHeaderFooterView>(headerFooterView _: T.Type) where T: RWGenericReusable {
        if let nib = T.nib {
            self.register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ viewType: T.Type = T.self) -> T? where T: RWGenericReusable {
        return self.dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as! T?
    }
}
