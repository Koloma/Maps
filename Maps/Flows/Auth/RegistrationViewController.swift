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

        // Do any additional setup after loading the view.
    }
    
    private func updateView() {
        loginTextField?.text = userName
    }

    @IBAction func registerAction(_ sender: Any) {
    }

}
