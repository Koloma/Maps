//
//  FilesManager.swift
//  Maps
//
//  Created by Alexander Kolomenskiy on 05.11.2021.
//

import UIKit

final class FilesManager: NSObject {

    static let defaultUserMarkerImage = UIImage(systemName: "person.fill")
    static let userImageName = "userImage"

    static func saveImage(imageName: String, image: UIImage) {

        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("Couldn't remove file at path: ", removeError)
            }
        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("Error saving file: ", error)
        }

    }

    static func loadImageFromDiskWith(fileName: String) -> UIImage? {

        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }
}
