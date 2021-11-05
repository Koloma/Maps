//
//  EditPhotoViewController.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 31.10.2021.
//

import UIKit

class EditPhotoViewController: UIViewController {


    @IBOutlet weak var imageView: UIImageView? {
        didSet {
            imageView?.contentMode = .scaleAspectFill
        }
    }

    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }

    var onSave: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView?.image = image
    }

    @IBAction func saveAction(_ sender: Any) {
         onSave?()
    }


}
