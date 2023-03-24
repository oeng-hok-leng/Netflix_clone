//
//  Extension.swift
//  Netflix Clone
//
//  Created by oeng hokleng on 17/3/23.
//

import UIKit


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

extension UIView {
    func addSubviews(_ views: UIView...){
        for view in views {
            addSubview(view)
        }
    }
}
