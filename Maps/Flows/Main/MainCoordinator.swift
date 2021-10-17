//
//  MainCoordinator.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import UIKit

final class MainCoordinator: BaseCoordinator {

    var onLogout: (() -> Void)?

    private var navigationController: UINavigationController?

    private let username: String?

    init(username: String?) {
        self.username = username
    }

    override func start() {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MenuViewController.self)

        viewController.onLogout = { [weak self] in
            self?.onLogout?()
        }

        viewController.onShowMap = { [weak self] in
            self?.showMap()
        }

        if let username = username {
            viewController.userName = "Hello, \(username)"
        } else {
            viewController.userName = nil
        }

        let navController = UINavigationController(rootViewController: viewController)
        setAsRoot(navController)
        self.navigationController = navController
    }

    func showMap() {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MapViewController.self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
