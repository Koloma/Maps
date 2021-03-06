//
//  AuthCoordinator.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import UIKit

final class AuthCoordinator: BaseCoordinator {

    var onFinishFlow: ((String) -> Void)?

    private var navigationController: UINavigationController?

    override func start() {
        let viewController = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(AuthViewController.self)

        viewController.onAuthSucces = { [weak self] username in
            self?.onFinishFlow?(username)
        }

        viewController.onRecoveryAction = { [weak self] in
            self?.showRecovery()
        }

        viewController.onRegistationAction = {[weak self] username in
            self?.showRegistration(userName: username)
        }

        let navController = UINavigationController(rootViewController: viewController)
        setAsRoot(navController)
        self.navigationController = navController
    }

    func showRecovery() {
        let viewController = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(RecoverViewController.self)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showRegistration(userName: String?) {
        let viewController = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(RegistrationViewController.self)
        viewController.userName = userName
        navigationController?.pushViewController(viewController, animated: true)
    }

}
