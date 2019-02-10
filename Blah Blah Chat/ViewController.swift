//
//  ViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 10.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let logger = Logger.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        logger.state(message: "View is created and loaded into memory")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logger.state(message: "The view is about to be presented on screen")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger.state(message: "The view is just presented on the screen")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logger.state(message: "The view is going to set up subviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logger.state(message: "The subviews of the view have been setup")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logger.state(message: "The view is about to be removed from screen")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logger.state(message: "The view is just removed from screen")
    }


}

