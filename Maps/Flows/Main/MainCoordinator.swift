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
        super.init()
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


        viewController.onTakePictures = { [weak self] in
            self?.showPhotoPicker()
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

    func showSelfi(image: UIImage) {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(EditPhotoViewController.self)
        viewController.image = image
        navigationController?.present(viewController, animated: true, completion: nil)
    }

    func showPhotoPicker() {
        let viewController = UIImagePickerController()
        viewController.sourceType = .camera
        viewController.allowsEditing = true
        viewController.delegate = self
        navigationController?.present(viewController, animated: true, completion: nil)
    }
}

extension MainCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = getImageFrom(info: info) {

        }

    }

    func getImageFrom(info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {

        if let image = info[.editedImage] as? UIImage {
            return image
        }

        if let image = info[.originalImage] as? UIImage {
            return image
        }

        return nil
    }
}
