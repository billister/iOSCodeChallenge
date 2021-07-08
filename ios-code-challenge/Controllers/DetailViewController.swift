//
//  DetailViewController.swift
//  ios-code-challenge
//
//  Created by Joe Rocca on 5/31/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var categoriesLabel: UILabel?
    @IBOutlet weak var ratingLabel: UILabel?
    @IBOutlet weak var reviewCountLabel: UILabel?
    @IBOutlet weak var priceLabel: UILabel?
    @IBOutlet weak var thumbnailImageView: UIImageView?
    
    let notificationName = NSNotification.Name(rawValue: "favoriteNotification")
    
    lazy private var favoriteBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Star-Outline"), style: .plain, target: self, action: #selector(onFavoriteBarButtonSelected(_:)))

    //need objc for collapseSecondaryViewController method in AppDelegate
    @objc var detailItem: YLPBusiness?
    
    private var _favorite: Bool = false
    private var isFavorite: Bool {
        get {
            return _favorite
        } 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        navigationItem.rightBarButtonItems = [favoriteBarButtonItem]
    }
    
    private func configureView() {
        guard let detailItem = detailItem else {
            nameLabel?.text = "No Business Selection Made Yet!"
            categoriesLabel?.text = ""
            ratingLabel?.text = ""
            reviewCountLabel?.text = ""
            priceLabel?.text = ""
            return }
        nameLabel?.text = detailItem.name
        categoriesLabel?.text = detailItem.categoriesString
        ratingLabel?.text = detailItem.ratingString
        reviewCountLabel?.text = detailItem.reviewCountString
        priceLabel?.text = detailItem.price
        thumbnailImageDownload(urlString: detailItem.thumbnailURL)
        _favorite = detailItem.isFavorite
        updateFavoriteBarButtonState()
    }
    
    private func updateFavoriteBarButtonState() {
        favoriteBarButtonItem.image = isFavorite ? UIImage(named: "Star-Filled") : UIImage(named: "Star-Outline")
    }
    
    @objc private func onFavoriteBarButtonSelected(_ sender: Any) {
        _favorite.toggle()
        updateFavoriteBarButtonState()
        
        guard let detailItem = detailItem else {
            return }
        
        detailItem.isFavorite = isFavorite
        NotificationCenter.default.post(name: notificationName, object: detailItem)
    }
    
    func thumbnailImageDownload(urlString: String) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        let placeholderImage = UIImage(named: "forkKnife")
        
        self.thumbnailImageView?.setImageWith(request, placeholderImage: placeholderImage, success: { [weak self] (request, response, image) in
            guard let strongSelf = self else { return }
            strongSelf.thumbnailImageView?.image = image
        }, failure: {  [weak self] (request, response, error) in
            guard let strongSelf = self else { return }
            strongSelf.thumbnailImageView?.image = placeholderImage
        })
        
    }
}

extension DetailViewController: BusinessSelectionDelegate {
    func businessSelected(_ newBusiness: YLPBusiness) {
        detailItem = newBusiness
        configureView()
    }
}
