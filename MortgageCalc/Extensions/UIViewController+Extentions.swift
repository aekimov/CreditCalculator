//
//  UIViewController+Extentions.swift
//  MortgageCalc
//
//  Created by Artem Ekimov on 1/21/22.
//

import UIKit

enum AlertAction {
    case cancel
    case delete
}

extension UIViewController {
        
    func showAlert(title: String, message: String, actionTitle: String, handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            handler?()
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
    
    func showAlert(title: String, message: String, cancelTitle: String, actionTitle: String, handler: ((AlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) {  _ in
            handler?(.cancel)
        }
        let confirmAction = UIAlertAction(title: actionTitle, style: .destructive) { _ in
            handler?(.delete)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
    
}
