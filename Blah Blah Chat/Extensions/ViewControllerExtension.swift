//
//  ViewControllerExtension.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 13.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String?, retry: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let retry = retry {
            let retryAction = UIAlertAction(title: "Повторить", style: .default) { _ in
                retry()
            }
            alert.addAction(retryAction)
        }

        let окAction  = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(окAction)
        present(alert, animated: true, completion: nil)
    }

}
