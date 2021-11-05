//
//  UIImageView+rounded.swift
//  Maps
//
//  Created by Коломенский Александр on 05.11.2021.
//

import UIKit

extension UIImageView {

    func rounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
