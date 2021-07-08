//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

@objc protocol BusinessSelectionDelegate: AnyObject {
  func businessSelected(_ newBusiness: YLPBusiness)
}

class MasterViewController: UITableViewController {

    @objc var detailDelegate: BusinessSelectionDelegate?

    lazy private var dataSource: NXTDataSource? = {
        guard let dataSource = NXTDataSource(objects: nil) else { return nil }
        dataSource.tableViewDidReceiveData = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
        }
     
        dataSource.tableViewDidSelectCell = { [weak self] (object) in
            guard let strongSelf = self else { return }
            if let detailViewController = strongSelf.detailDelegate as? DetailViewController,
               let business = object as? YLPBusiness {
                detailViewController.businessSelected(business)
            }
        }
        
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        let query = YLPSearchQuery(location: "5550 West Executive Dr. Tampa, FL 33609")
        AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in
            guard let strongSelf = self,
                let dataSource = strongSelf.dataSource,
                var businesses = searchResult?.businesses else {
                    return
            }
            businesses.sort(by:{
                $0.distance.decimalValue < $1.distance.decimalValue
            })
            dataSource.setObjects(businesses)
            strongSelf.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false
        super.viewDidAppear(animated)
    }

}
