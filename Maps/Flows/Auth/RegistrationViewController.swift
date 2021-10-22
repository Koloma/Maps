//
//  RegistrationViewController.swift
//  Maps
//
//  Created by Коломенский Александр on 18.10.2021.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

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
        loginTextField?.text = userName
    }

    @IBAction func registerAction(_ sender: Any) {
        guard let userName = loginTextField?.text,
              let password = passwordTextField?.text
        else { return }

        UserManager.instance.saveUser(username: userName, password: password)

        let alertViewController = UIAlertController(
            title: "Successful registration",
            message: "User \(userName) registered successful",
            preferredStyle: .alert
        )
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true){
                self?.loginTextField.text = nil
                self?.passwordTextField.text = nil
            }
        }))
        present(alertViewController, animated: true)

    }

}
