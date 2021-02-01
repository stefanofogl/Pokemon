//
//  ActivityIndicator.swift
//  Pokemon
//
//  Created by Stefano Foglia on 01/02/21.
//

import UIKit

class ActivityIndicator {

    static let shared = ActivityIndicator()

    var activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

    func showActivityIndicatory(view: UIViewController?) {
        if let view = view {
            activityView.center = view.view.center
            activityView.hidesWhenStopped = true
            view.view.addSubview(activityView)
            activityView.startAnimating()
        }
    }

    func hideActivityIndicator() {
        activityView.stopAnimating()
    }
}
