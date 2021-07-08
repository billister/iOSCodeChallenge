//
//  SpinnerView.swift
//  ios-code-challenge
//
//  Created by Billie West on 7/8/21.
//  Copyright © 2021 Dustin Lange. All rights reserved.
//

import UIKit

class SpinnerView: UIView {

    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    //common func to init our view
    private func setupView() {
        backgroundColor = .black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        layer.cornerRadius = 10.0
    }
    
    func startSpinner() {
        spinner.startAnimating()
        isHidden = false
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
        isHidden = true
    }
}
