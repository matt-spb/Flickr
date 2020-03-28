//
//  DetailPhotoVC.swift
//  Flickr
//
//  Created by matt_spb on 01.03.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit
import SwiftyJSON
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
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var photoModel: PhotoModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        setImage()
        scrollView.delegate = self
        setZoomScale(scrollView.bounds.size)
        navigationController?.navigationBar.isHidden = false

        print("url: \(photoModel.url), views: \(photoModel.views), title: \(photoModel.title ?? "no title"), latitude: \(photoModel.latitude), longitude: \(photoModel.longitude), dateUpload: \(photoModel.dateUpload)")
        
    }
    
    fileprivate func configureVC() {
        view.backgroundColor = .systemBackground
        getUserInfo()
            
        titleLabel.text = photoModel.title
        dateLabel.text = photoModel.dateUpload
        viewsLabel.text = "\(photoModel.views) views"
        
        userPic.layer.cornerRadius = userPic.frame.height / 2
        
    }
    
    func setImage() {
        guard let imgURL = URL(string: photoModel.url) else { return }
        photoImage.contentMode = .scaleAspectFit
        photoImage.sd_setImage(with: imgURL)
        
        let imageHeight = photoModel.height
        let imageWidth = photoModel.width
        let imageAspectRatio = CGFloat(imageWidth / imageHeight)
        
        heightConstraint.constant = view.frame.width / imageAspectRatio
        view.layoutIfNeeded()
    }
    
    func setZoomScale(_ scrollViewSize: CGSize) {
        let imageSize = photoImage.bounds.size
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1.5
        scrollView.zoomScale = minScale
    }
    
    func getUserInfo() {
        APIWrapper.getUserInfo(id: photoModel.userID, success: { response in
            print("response: \(response)")
            
            let userInfo = JSON(response)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.nameLabel.text = userInfo["person"]["realname"]["_content"].stringValue
            }
            
        }) { error in
            print(error ?? "")
        }
    }
}


extension DetailPhotoVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImage
    }
}

/*
 let title: String?
 let width: Double
 let height: Double
 let url: String
 let iconServer: Int
 let userID: String
 let latitude: Int
 let longitude: Int
 let dateUpload: String
 let views: Int
 */
