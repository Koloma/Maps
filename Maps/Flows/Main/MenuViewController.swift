//
//  MenuViewController.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//
import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    
    var onShowMap: (() -> Void)?
    var onLogout: (() -> Void)?
    var onTakePictures: (() -> Void)?

    var userName: String? {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
    }

    private func updateView() {
        titleLabel?.text = userName
    }

    @IBAction func takePicturesAction(_ sender: Any) {
        onTakePictures?()
    }

    @IBAction func showMapAction(_ sender: Any) {
        onShowMap?()
    }

    @IBAction func logoutAction(_ sender: Any) {
        UserManager.instance.logout()
        onLogout?()
    }

}
