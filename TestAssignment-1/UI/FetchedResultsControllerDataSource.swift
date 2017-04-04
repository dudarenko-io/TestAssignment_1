//
//  FetchedResultsControllerDataSource.swift
//  TestAssignment-1
//
//  Created by Dudarenko Ilya on 02/04/2017.
//  Copyright © 2017 Dudarenko Ilya. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class FetchedResultsControllerDataSource: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    private let tableView: UITableView
    var fetchedResultsController: NSFetchedResultsController<NewsTitle>!
    
    // MARK: - Init
    
    init(with tableView:UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionInfo = fetchedResultsController.sections?[section] {
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTableViewCell.self))!
        
        // Configure the cell...
        if let newsCell = cell as? NewsTableViewCell {
            let viewModel = object(at: indexPath)
            newsCell.configure(with:viewModel)
        }
        
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        
//    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetching error")
        }
        tableView.reloadData()
    }
    
    // MARK: - Private
    
    private func object(at index:IndexPath) -> NewsCellViewModel {
        let model = fetchedResultsController.object(at: index)
        return NewsCellViewModel(with: model)
    }
}
