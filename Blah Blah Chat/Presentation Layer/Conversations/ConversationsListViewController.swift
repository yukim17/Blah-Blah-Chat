//
//  ConversationsListViewController.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 20.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {

    @IBOutlet var convListTableView: UITableView!
    
    private var model: ConversationModelProtocol
    private let presentationAssembly: PresentationAssemblyProtocol
    private var emitter: Emitter!
    
    init(model: ConversationModelProtocol, presentationAssembly: PresentationAssemblyProtocol) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        model.reloadThemeSettings()
        setupTableView()
        
        model.dataSource = ConversationDataSource(delegate: convListTableView, fetchRequest: model.frService.allConversations()!, context: model.frService.saveContext)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupNavBar()
    }
    
    private func setupTableView() {
        self.convListTableView.delegate = self
        self.convListTableView.dataSource = self
        
        let nib = UINib(nibName: "ConversationTableViewCell", bundle: nil)
        self.convListTableView.register(nib, forCellReuseIdentifier: "chatCell")
        
        self.convListTableView.rowHeight = UITableView.automaticDimension
        self.convListTableView.estimatedRowHeight = 67
    }
    
    private func setupNavBar() {
        navigationItem.title = "Blah Blah Chat"
        
        let profileButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-outline-of-a-face-50"), style: .plain, target: self, action: #selector(self.showProfile) )
        profileButton.tintColor = UIColor.gray
        navigationItem.rightBarButtonItem = profileButton
        
        let themesButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-settings-filled-50"), style: .plain, target: self, action: #selector(self.showThemeSettings) )
        
        navigationItem.leftBarButtonItem = themesButton
    }

    @objc func showProfile() {
        let controller = presentationAssembly.profileViewController()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        emitter = Emitter(view: navigationController.view)
        present(navigationController, animated: true)
    }

    @objc func showThemeSettings() {
        let controller = presentationAssembly.themesViewController { [weak self] (controller: ThemesViewControllerSwift, selectedTheme: UIColor?) in
            guard let theme = selectedTheme else { return }
            controller.view.backgroundColor = theme
            self?.model.saveSettings(for: theme)
        }
        let navigationController = UINavigationController()
        navigationController.viewControllers = [controller]
        emitter = Emitter(view: navigationController.view)
        present(navigationController, animated: true)
    }

}

// MARK: - Table View Delegate Methods

extension ConversationsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversation = model.dataSource?.fetchedResultsController.object(at: indexPath) else { return }
        let controller = presentationAssembly.chatViewController(model: ChatModel(communicationService: model.communicationService, frService: model.frService, conversation: conversation))

        controller.navigationItem.title = conversation.user?.name
        navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Table View Datasource

extension ConversationsListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsCount = model.dataSource?.fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionsCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = model.dataSource?.fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "chatCell"
        var convCell: ConversationTableViewCell
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationTableViewCell {
            convCell = cell
        } else {
            convCell = ConversationTableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        if let conversation = model.dataSource?.fetchedResultsController.object(at: indexPath) {
            if let user = conversation.user {
                convCell.name = user.name
            }
            convCell.configureCell(conversation: conversation)
        }
        
        return convCell
    }
}
