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
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? false
        super.viewDidAppear(animated)
    }
    
    func locationWasUpdated() {
        
        guard let newLatitude = latitude, let newLongitude = longitude else {
            return
        }
        
        let query = YLPSearchQuery(latitude: NSNumber(value: newLatitude), andLongitude: NSNumber(value: newLongitude))
        AFYelpAPIClient.shared().search(with: query, completionHandler: { [weak self] (searchResult, error) in
            guard let strongSelf = self,
                  let dataSource = strongSelf.dataSource,
                  var businesses = searchResult?.businesses else {
                return
            }
            businesses.sort(by:{
                $0.distanceMiles.decimalValue < $1.distanceMiles.decimalValue
            })
            strongSelf.allBusinesses = businesses
            dataSource.setObjects(businesses)
            strongSelf.tableView.reloadData()
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
        locationWasUpdated()
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
    }
}
