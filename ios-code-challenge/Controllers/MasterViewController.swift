//
//  MasterViewControllerS.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol BusinessSelectionDelegate: AnyObject {
  func businessSelected(_ newBusiness: YLPBusiness)
}

class MasterViewController: UITableViewController, CLLocationManagerDelegate, UISearchResultsUpdating {

    //@objc so the ObjC appDelegate can set this
    @objc var detailDelegate: BusinessSelectionDelegate?
    var locationManager: CLLocationManager?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    let searchController = UISearchController()
    var allBusinesses: [YLPBusiness]?
    let limit: NSNumber = 50
    var fetchingMoreBusinesses = false
    let notificationName = NSNotification.Name(rawValue: "favoriteNotification")
    var spinnerView = SpinnerView()
    
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
        
        dataSource.checkLastCellForPagination = { [weak self] (row) in
            guard let strongSelf = self, let tableRow = row else { return }
            let businessCount = strongSelf.allBusinesses?.count ?? 0
            let rowOffset = tableRow.intValue + 1
            if rowOffset >= businessCount && !strongSelf.fetchingMoreBusinesses {
                strongSelf.fetchingMoreBusinesses = true
                strongSelf.fetchNextBusinesses(offset: NSNumber(integerLiteral: rowOffset))
            }
        }
        
        return dataSource
    }()

    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        allBusinesses = [YLPBusiness]()
        
        NotificationCenter.default.addObserver(self, selector: #selector(markOrRemoveFavorite(notification:)), name: notificationName, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false
        super.viewDidAppear(animated)

        spinnerView = SpinnerView(frame: CGRect(x: view.frame.midX, y: 40, width: 60, height: 60))
        view.addSubview(spinnerView)
        spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: Query & Yelp Service Call Methods
    func fetchNextBusinesses(offset: NSNumber) {
        spinnerView.startSpinner()
        guard let newLatitude = latitude, let newLongitude = longitude else {
            return
        }
        
        let query = YLPSearchQuery(latitude: NSNumber(value: newLatitude), longitude: NSNumber(value: newLongitude), limit: limit, offset: offset)

        callYelpService(query: query)
    }
    
    func callYelpService(query: YLPSearchQuery) {
        AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in
            guard let strongSelf = self,
                  let dataSource = strongSelf.dataSource,
                  let businesses = searchResult?.businesses else {
                return
            }
            strongSelf.allBusinesses?.append(contentsOf: businesses)
            strongSelf.allBusinesses?.sort(by:{
                $0.distanceMiles.decimalValue < $1.distanceMiles.decimalValue
            })
            dataSource.setObjects(strongSelf.allBusinesses)
            strongSelf.tableView.reloadData()
            strongSelf.fetchingMoreBusinesses = false
            strongSelf.spinnerView.stopSpinner()
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        var filteredBusinesses = allBusinesses?.filter({
            $0.name.contains(text) || $0.categoriesString.contains(text)
        })
        
        if text.isEmpty {
            filteredBusinesses = allBusinesses
        }
    
        dataSource?.setObjects(filteredBusinesses)
        tableView.reloadData()
    }
    
    //MARK: Location Manager Methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager?.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        fetchNextBusinesses(offset: 0)
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
    }
    
    //MARK: Notification named favoriteNotification Methods
    @objc func markOrRemoveFavorite(notification: NSNotification) {
        guard let business = notification.object as? YLPBusiness else {
            return
        }
        let businessToUpdate = allBusinesses?.first(where: {
                                                $0.identifier == business.identifier })
        businessToUpdate?.isFavorite = business.isFavorite
    }
}
