//
//  AppCoordinator.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import Foundation

final class AppCoordinator: BaseCoordinator {

    private var username: String?

    override func start() {
        if UserManager.instance.isAuthorized {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }

    func showMainFlow() {
        let coordinator = MainCoordinator(username: username)
        coordinator.onLogout = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }

    func showAuthFlow() {
        let coordinator = AuthCoordinator()
        coordinator.onFinishFlow = { [weak self, weak coordinator] username in
            self?.username = username
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }

}
