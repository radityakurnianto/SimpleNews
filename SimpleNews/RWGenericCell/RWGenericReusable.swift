//
//  RWGenericReusable.swift
//  RWGenericCell
//
//  Created by Raditya Kurnianto on 1/10/19.
//

import UIKit

public protocol RWGenericReusable: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

public extension RWGenericReusable {
    static var reuseIdentifier: String { return String(describing: self) }
    static var nib: UINib? { return UINib(nibName: String(describing: self), bundle: Bundle(for: self)) }
}
