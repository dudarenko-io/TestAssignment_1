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
        
        tableRefreshControl.beginRefreshing()
        tableView.contentOffset = CGPoint(x: 0, y: -tableRefreshControl.frame.size.height)
        reloadData()
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
        newsService.updateNewsList { [weak self] (error) in
            self?.tableRefreshControl.endRefreshing()
            if error != nil {
                self?.showAlert(with: error!)
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
    
    // MARK: - Alert
    
    func showAlert(with error:Error) {
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
