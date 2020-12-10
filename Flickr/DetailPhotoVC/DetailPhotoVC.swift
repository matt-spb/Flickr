//
//  DetailPhotoVC.swift
//  Flickr
//
//  Created by matt_spb on 01.03.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//


// при повторном нажатии фотки ДетайлВК открывается не с центрированной фоткой. Исправить
// как это можно отдебажить, чтобы понять где что не срабатывает?

// лоадинг вью работает криво после перехода на кодабл

import UIKit
import SDWebImage

class DetailPhotoVC: UIViewController {
    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var photoModel: Photo!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureUserPic()
        setImage()
        innerScrollView.delegate = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConstraintsForSize(containerView.bounds.size)
        print("debug: viewDidLayoutSubviews size = \(containerView.bounds.size)")
        updateMinZoomScaleForSize(containerView.bounds.size)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.isHidden = false
    }
    
    
    fileprivate func configureVC() {
        titleLabel.text     = photoModel.title
        dateLabel.text      = photoModel.dateUpload.convertToDateString()
        self.nameLabel.text = photoModel.ownername
        
        if photoModel.intViews > 1000 {
            viewsLabel.text = String(format: "%.1fK views", Double(photoModel.intViews) / 1000)
        } else {
            viewsLabel.text = String(format: "%.0f views", photoModel.intViews)
        }
    }
    
    
    private func configureUserPic() {
        userPic.layer.cornerRadius = userPic.bounds.height / 2
        guard let user = photoModel.user else { return }
        guard let userPicStr = user.userPicUrl else { return }
        guard let userPicUrl = URL(string: userPicStr) else { return }
        userPic.sd_setImage(with: userPicUrl)
    }
    
    
    func setImage() {
        guard let imgURL = URL(string: photoModel.url_c) else { return }
        photoImage.contentMode = .scaleAspectFit
        photoImage.sd_setImage(with: imgURL)
        
        let imageHeight = photoModel.height
        let imageWidth = photoModel.width
        let imageAspectRatio = CGFloat(imageWidth / imageHeight)
        heightConstraint.constant = view.frame.width / imageAspectRatio
        
        view.layoutIfNeeded()
    }
}


extension DetailPhotoVC {
    func updateMinZoomScaleForSize(_ size: CGSize) {
        let imageSize = photoImage.bounds.size
        let widthScale = size.width / imageSize.width
        let heightScale = size.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        innerScrollView.minimumZoomScale = minScale
        innerScrollView.maximumZoomScale = 1.5
        innerScrollView.zoomScale = minScale
    }
    
    
    func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - photoImage.frame.height) / 2)
        print("debug: size = \(size)")
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - photoImage.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
}


extension DetailPhotoVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(containerView.bounds.size)
        print("debug: scrollViewDidZoom size = \(containerView.bounds.size)")
    }
}
