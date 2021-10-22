//
//  RegistrationViewController.swift
//  Maps
//
//  Created by Коломенский Александр on 18.10.2021.
//

import UIKit
import RxCocoa
import RxSwift

class RegistrationViewController: UIViewController {

    let disposeBag = DisposeBag()

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!

    var userName: String? {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLoginBindings()
        updateView()

    }
    
    private func updateView() {
        loginTextField?.text = userName
    }

    func configureLoginBindings() {
        Observable.combineLatest(loginTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty)
            .map { (userName, password) in
                !userName.isEmpty && password.count >= 6
            }
            .bind(to: registrationButton.rx.isEnabled)
            .disposed(by: disposeBag)
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
