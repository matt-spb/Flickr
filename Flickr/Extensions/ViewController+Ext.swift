//
//  ViewController+Ext.swift
//  Flickr
//
//  Created by matt_spb on 03.03.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit

fileprivate var containerView: UIView?

extension UIViewController {
    
    func showLoadingView() {
        
        containerView = UIView(frame: view.bounds)
        guard let containerView = containerView else {
            return
        }
        view.addSubview(containerView)
        
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0
        
        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    func dismissLoadingView() {
        
        DispatchQueue.main.async {
            containerView?.removeFromSuperview()
            containerView = nil
        }

        
    }
}
