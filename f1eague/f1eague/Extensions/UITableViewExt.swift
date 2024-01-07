//
//  UITableViewExt.swift
//  f1eague
//
//  Created by Sanem Ökte on 27.12.2023.
//

import UIKit

extension UITableView {
    public func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
         let className = String(describing: cellType)
         let nib = UINib(nibName: className, bundle: bundle)
         register(nib, forCellReuseIdentifier: className)
    }
    
    public func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
         cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(with cellType: T.Type, for indexPath: IndexPath) -> T {
         return self.dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath) as! T
    }
}
