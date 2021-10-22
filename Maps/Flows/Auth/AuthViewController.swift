//
//  AuthViewController.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var onAuthSucces: ((String) -> Void)?
    var onRecoveryAction: (() -> Void)?
    var onRegistationAction: ((String?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginAction(_ sender: Any) {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text
        else { return }

        if UserManager.instance.authorize(username: username, password: password) {
            onAuthSucces?(username)
        }
    }

    @IBAction func recoverAction(_ sender: Any) {
        onRecoveryAction?()
    }

    @IBAction func registrationAction(_ sender: Any) {
        guard let username = usernameTextField.text,
              !username.replacingOccurrences(of: " ", with: "").isEmpty
        else {
            onRegistationAction?(nil)
            return
        }
        onRegistationAction?(username)
    }

}

final class AuthRouter: BaseRouter {

    func toMain() {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MenuViewController.self)
        let navController = UINavigationController(rootViewController: viewController)
        show(navController, style: .root)
    }

    func toRecovery(userName: String?) {
        let viewController = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(RecoverViewController.self)
        show(viewController, style: .push(animated: true))
    }

    func toRegistrationuser (userName: String?){
        let viewController = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(RegistrationViewController.self)
        show(viewController, style: .push(animated: true))
    }
}

