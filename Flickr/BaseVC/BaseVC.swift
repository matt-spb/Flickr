//
//  BaseVC.swift
//  Flickr
//
//  Created by matt_spb on 05.03.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    var loaderView: FlickrLoader?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func setupActivityIndicatior() {
        loaderView = FlickrLoader(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        loaderView?.center = view.center
        loaderView?.hideIfStopAnimate = true
        guard  let loaderView = loaderView else { return }
        view.addSubview(loaderView)
        view.bringSubviewToFront(loaderView)
    }
}
