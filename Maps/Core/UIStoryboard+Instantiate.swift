//
//  UIStoryboard+Instantiate.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable { }

extension UIStoryboard {

    func instantiateViewController<T: UIViewController>(_: T.Type) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T
        else {
            fatalError("View controller с идентификатором \(T.storyboardIdentifier) не найден")
        }
        return viewController
    }

    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController =
                self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("View controller с идентификатором \(T.storyboardIdentifier) не найден")
        }
        return viewController
    }

}
