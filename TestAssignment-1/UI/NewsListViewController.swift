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
    
    lazy var newsService: NewsService = {
        let service = NewsServiceImplementation()
        
        let coreDataStack = CoreDataStack()
        service.coreDataStack = coreDataStack

        service.newsListParser = NewsListParser(with: coreDataStack.backgroundContext)
        service.newsDetailsParser = NewsDetailParser(with: coreDataStack.backgroundContext)
        service.transport = SessionManager()
        service.errorHandler = ErrorHandlerImplementation()
        
        return service
    }()
    
    var dataSource: FetchedResultsControllerDataSource!
    
    fileprivate static let publicationDateKey = "publicationDate"
    fileprivate let tableRefreshControl = UIRefreshControl()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
        
        tableRefreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.refreshControl = tableRefreshControl
        
        reloadData()
        tableView.reloadData()
    }
    
    func setupDataSource() {
        let resultsController = self.newsService.resultsController
        
        self.dataSource = FetchedResultsControllerDataSource(with: self.tableView)
        dataSource.fetchedResultsController = resultsController
        
        self.tableView.dataSource = dataSource
        resultsController.delegate = dataSource
        
        do {
            try resultsController.performFetch()
        } catch {
            
        }
    }
    
    @objc fileprivate func reloadData() {
        tableRefreshControl.beginRefreshing()
        tableView.contentOffset = CGPoint(x: 0, y: -tableRefreshControl.frame.size.height)
        
        newsService.updateNewsList { [weak self] (error) in
            self?.tableRefreshControl.endRefreshing()
            if error != nil {
                // alert
                return
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? NewsDetailViewController,
            let cell = sender as? NewsTableViewCell
        {
            detailVC.service = newsService
            detailVC.contentID = cell.newsIdentifier
        }
    }
}
