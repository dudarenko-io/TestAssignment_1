//
//  NewsListViewController.swift
//  
//
//  Created by Dudarenko Ilya on 19/03/2017.
//
//

import UIKit

class NewsListViewController: UITableViewController {
    
    var titles = [NewsCellViewModel]()
    let service = NewsService()
    let tableRefreshControl = UIRefreshControl()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
        
        tableRefreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.refreshControl = tableRefreshControl
        
        tableRefreshControl.beginRefreshing()
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func reloadData() {
        service.obtainNews { (viewModels) in
            self.titles.append(contentsOf: viewModels)
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)

        // Configure the cell...
        if let newsCell = cell as? NewsTableViewCell {
            newsCell.configure(with: titles[indexPath.row])
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? NewsDetailViewController,
            let cell = sender as? NewsTableViewCell {
                detailVC.contentID = "7924"
        }
    }
}
