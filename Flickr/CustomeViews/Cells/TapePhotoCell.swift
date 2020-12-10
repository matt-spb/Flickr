//
//  TapePhotoCell.swift
//  Flickr
//
//  Created by matt_spb on 24.02.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit
import SDWebImage

class TapePhotoCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    static let cellID: String = "tapePhotoCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.contentMode = .scaleAspectFit
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configure(with photoModel: Photo) {
        configureUserInfoFor(photoModel)
        
        guard let url = URL(string: photoModel.url) else {
            photoImageView.image = nil
            return
        }
        photoImageView.sd_setImage(with: url)
        
        if photoModel.intViews > 1000 {
            viewsLabel.text = String(format: "%.1fK views", Double(photoModel.intViews) / 1000)
        } else {
            viewsLabel.text = "\(photoModel.intViews) views"
        }
        
        dateLabel.text = photoModel.dateUpload.convertToDateString()
        nameLabel.text = photoModel.ownername
        
        borderView.layer.borderWidth = 0
        borderView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    
    private func configureUserInfoFor(_ photo: Photo) {
        userPic.layer.cornerRadius = userPic.bounds.height / 2
        guard let user = photo.user, let userPicStr = user.userPicUrl else { return }
        guard let userPicUrl = URL(string: userPicStr) else { return }
        userPic.sd_setImage(with: userPicUrl)
    }
}


