//
//  MessageDataSource.swift
//  Blah Blah Chat
//
//  Created by Екатерина on 16.04.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import CoreData
import UIKit

class MessagesDataSource: NSObject {
    
    var delegate: DataSourceDelegate?
    var fetchedResultsController: NSFetchedResultsController<Message>
    
    init(delegate: DataSourceDelegate?, fetchRequest: NSFetchRequest<Message>, context: NSManagedObjectContext) {
        self.delegate = delegate
        fetchedResultsController = NSFetchedResultsController<Message>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        perfromFetch()
    }
    
    private func perfromFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fetch -- MessageDataSource")
        }
    }
    
}

extension MessagesDataSource: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        DispatchQueue.main.async {
            switch type {
            case .delete:
                if let indexPath = indexPath {
                    self.delegate?.deleteRows(at: [indexPath], with: .automatic)
                }
            case .insert:
                if let newIndexPath = newIndexPath {
                    self.delegate?.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .update:
                if let indexPath = indexPath {
                    self.delegate?.reloadRows(at: [indexPath], with: .automatic)
                }
            case .move:
                if let indexPath = indexPath {
                    self.delegate?.deleteRows(at: [indexPath], with: .automatic)
                }
                
                if let newIndexPath = newIndexPath {
                    self.delegate?.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.delegate?.beginUpdates()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.delegate?.endUpdates()
        }
    }
}


protocol DataSourceDelegate: class {
    func beginUpdates()
    func endUpdates()
    
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
}
