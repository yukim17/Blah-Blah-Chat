//
//  UITableView.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 19.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

extension UITableView {

    func scrollToBottom(animated: Bool) {
        guard numberOfRows(inSection: 0) != 0 else { return }

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection: self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }

    func scrollToTop(animated: Bool) {
        guard numberOfRows(inSection: 0) != 0 else { return }

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}
