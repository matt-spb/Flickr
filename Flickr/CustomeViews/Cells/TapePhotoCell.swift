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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.contentMode = .scaleAspectFit
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func configure(with photoModel: PhotoModel) {
        guard let user = photoModel.user else { return }
        configureUserInfoWith(user: user)
        
        guard let url = URL(string: photoModel.url) else {
            photoImageView.image = nil
            return
        }
        photoImageView.sd_setImage(with: url)
        
        if photoModel.views > 1000 {
            viewsLabel.text = String(format: "%.1fK views" , photoModel.views / 1000)
        } else {
            viewsLabel.text = "\(photoModel.views) views"
        }
        
        dateLabel.text = photoModel.dateUpload.convertToDateString()
        
        borderView.layer.borderWidth = 0
        borderView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    
    private func configureUserInfoWith(user: User) {
        userPic.layer.cornerRadius = userPic.bounds.height / 2
        guard let userPicStr = user.userPicUrl else { return }
        guard let userPicUrl = URL(string: userPicStr) else { return }
        userPic.sd_setImage(with: userPicUrl)
        
        nameLabel.text = user.ownerName
    }
}


