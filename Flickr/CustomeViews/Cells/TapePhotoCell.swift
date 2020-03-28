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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with photoModel: PhotoModel) {
        guard let url = URL(string: photoModel.url) else {
            photoImageView.image = nil
            return
        }
        
        photoImageView.sd_setImage(with: url)
        
//        photoImageView.sd_setImage(with: url) { (image, error, cache, url) in
//            let width = image?.size.width ?? 0.0
//            let height = image?.size.height ?? 0.0
//            
//            let size = CGSize(width: width, height: height)
//            
//            photoModel.size = size
//        }
    }    
}


