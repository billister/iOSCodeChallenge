//
//  FavoritesTableViewController.swift
//  ios-code-challenge
//
//  Created by Billie West on 7/8/21.
//  Copyright © 2021 Dustin Lange. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
//class FavoritesTableViewController: UITableViewController, BusinessFavoritedDelegate {
    var favoriteBusinesses: [YLPBusiness]?
    
    //@objc so the ObjC appDelegate can set this
    @objc var detailDelegate: BusinessSelectionDelegate?
    let notificationName = NSNotification.Name(rawValue: "favoriteNotification")

    
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

    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        favoriteBusinesses = [YLPBusiness]()
        NotificationCenter.default.addObserver(self, selector: #selector(markOrRemoveFavorite(notification:)), name: notificationName, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false
        super.viewDidAppear(animated)
    }
 
    //MARK: Notification named favoriteNotification Methods
    @objc func markOrRemoveFavorite(notification: NSNotification) {
        guard let business = notification.object as? YLPBusiness else {
            return
        }
        
        if business.isFavorite {
            favoriteBusinesses?.append(business)
        } else {
            favoriteBusinesses = favoriteBusinesses?.filter({
                $0.identifier != business.identifier
            })
        }
        
        favoriteBusinesses?.sort(by:{
            $0.distanceMiles.decimalValue < $1.distanceMiles.decimalValue
        })
        
        if let businesses = favoriteBusinesses {
            dataSource?.setObjects(businesses)
        }
        
        tableView.reloadData()
    }
}
