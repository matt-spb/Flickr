//
//  PhotoCell.swift
//  Flickr
//
//  Created by matt_spb on 01.03.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

class PhotoCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var cellImage: UIImageView!
    
    static var reuseIdentifier: String { return "photoCell"}
    static var nib: UINib { return UINib(nibName: "PhotoCell", bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.clipsToBounds = true
        cellImage.contentMode = .scaleAspectFill
        cellImage.backgroundColor = .black
    }
    
    func configure(with photo: PhotoModel) {
        guard let url = URL(string: photo.url) else {
            cellImage.image = nil
            return
        }
        cellImage.sd_setImage(with: url)
    }

}
