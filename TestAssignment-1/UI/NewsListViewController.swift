//
//  NewsListViewController.swift
//  
//
//  Created by Dudarenko Ilya on 19/03/2017.
//
//

import UIKit
import CoreData

class NewsListViewController: UITableViewController {
    
    let service = NewsService()
    var dataSource: FetchedResultsControllerDataSource!
    
    fileprivate static let publicationDateKey = "publicationDate"
    fileprivate let tableRefreshControl = UIRefreshControl()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = FetchedResultsControllerDataSource(with: tableView)
        let fetchRequest:NSFetchRequest<NewsTitle> = NewsTitle.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: NewsListViewController.publicationDateKey, ascending: false)]
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                       managedObjectContext: service.viewContext,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        do {
            try resultsController.performFetch()
        } catch {
            
        }
        
        resultsController.delegate = dataSource
        dataSource.fetchedResultsController = resultsController
        tableView.dataSource = dataSource
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
        
        tableRefreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.refreshControl = tableRefreshControl
        
        tableRefreshControl.beginRefreshing()
        reloadData()
        tableView.reloadData()
    }
    
    @objc fileprivate func reloadData() {
        service.obtainNews { (viewModels) in
            self.tableRefreshControl.endRefreshing()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? NewsDetailViewController,
            let cell = sender as? NewsTableViewCell
        {
            detailVC.service = service
            detailVC.contentID = cell.newsIdentifier
        }
    }
}
