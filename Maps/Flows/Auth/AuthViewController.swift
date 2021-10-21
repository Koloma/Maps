//
//  AuthViewController.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 17.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

class AuthViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var onAuthSucces: ((String) -> Void)?
    var onRecoveryAction: (() -> Void)?
    var onRegistationAction: ((String?) -> Void)?

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        Observable.combineLatest(usernameTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty)
            .map { (userName, password) in
                !userName.isEmpty && password.count >= 6
            }
            .bind(to: loginButton.rx.isEnabled)
//            .subscribe{[weak self] isEnabled in
//                self?.loginButton.isEnabled = isEnabled
//            }
            .disposed(by: disposeBag)

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

