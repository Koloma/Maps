//
//  RecoverViewController.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import UIKit

class RecoverViewController: UIViewController {

    var userName: String? {
        didSet {
            usernameTextField?.text = userName
        }
    }

    @IBOutlet weak var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.text = userName
    }

    @IBAction func recoverAction(_ sender: Any) {

        guard let userName = usernameTextField.text,
              let user = UserManager.instance.loadUser(username: userName)
        else { return }

        let alertViewController = UIAlertController(
            title: "Password",
            message: user.password,
            preferredStyle: .alert
        )
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        present(alertViewController, animated: true, completion: nil)
    }

}
