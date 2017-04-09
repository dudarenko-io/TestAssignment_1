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
    let tableRefreshControl = UIRefreshControl()
    var dataSource: FetchedResultsControllerDataSource!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = FetchedResultsControllerDataSource(with: tableView)
        let fetchRequest:NSFetchRequest<NewsTitle> = NewsTitle.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publicationDate", ascending: false)]
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
    
    // MARK: - Table view delegate
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 88.0
//    }

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
