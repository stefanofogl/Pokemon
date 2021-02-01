//
//  AlertView.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import UIKit

class AlertView {

    static let shared = AlertView()

    func showError(title: String, message: String, view: UIViewController?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        if let view = view {
            view.present(alert, animated: true, completion: nil)
        }
    }
}
