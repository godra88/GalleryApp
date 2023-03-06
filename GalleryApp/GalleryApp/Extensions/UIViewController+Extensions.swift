//
//  UIViewController+Extensions.swift
//  GalleryApp
//
//  Created by Ivan Fabri on 03/03/2023.
//

import UIKit

extension UIViewController {
    public func showAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: String(localized: "globalOk"), style: .default, handler: nil)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    public func getErrorMessage(error: Error?) {
        switch error as? FetchError {
        case .downloadDataError:
            self.showAlert(title: String(localized: "alertWarning"), message: String(localized: "alertDownloadDataError"))
        case .downloadImageDataError:
            self.showAlert(title: String(localized: "alertWarning"), message: String(localized: "alertDownloadImageDataError"))
        case .invalidData:
            self.showAlert(title: String(localized: "alertWarning"), message: String(localized: "alertInvalidData"))
        case .badUrl:
            self.showAlert(title: String(localized: "alertWarning"), message: String(localized: "alertBadUrl"))
        case .none:
            self.showAlert(title: String(localized: "alertWarning"), message: String(localized: "alertGeneralError"))
        }
    }
}
