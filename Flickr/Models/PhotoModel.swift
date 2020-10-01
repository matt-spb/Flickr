//
//  PhotoModel.swift
//  Flickr
//
//  Created by matt_spb on 24.02.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit
import SwiftyJSON

class PhotoModel {
    
    var user: User?
    let title: String?
    let width: Double
    let height: Double
    let url: String
    let latitude: Int
    let longitude: Int
    let dateUpload: Double
    let views: Double
    var url_c: String {
        get {
            var str = url
            let lastPeriodIndex = str.lastIndex(of: ".")
            str.remove(at: str.index(before: lastPeriodIndex!))
            str.insert("c", at: str.index(before: lastPeriodIndex!))
            
            return str
        }
    }
    
    init(title: String?, width: Double, height: Double, url: String, latitude: Int, longitude: Int, dateUpload: Double, views: Double) {
        self.title          = title
        self.width          = width
        self.height         = height
        self.url            = url
        self.latitude       = latitude
        self.longitude      = longitude
        self.dateUpload     = dateUpload
        self.views          = views
    }
}

extension PhotoModel {
    convenience init(json: JSON) {
        
        let title       = json["title"].stringValue
        let width       = json["width_n"].doubleValue
        let height      = json["height_n"].doubleValue
        let url         = json["url_n"].stringValue
        let latitude    = json["latitude"].intValue
        let longitude   = json["longitude"].intValue
        let dateUpload  = json["dateupload"].doubleValue
        let views       = json["views"].doubleValue
        
        self.init(title: title, width: width, height: height, url: url, latitude: latitude, longitude: longitude, dateUpload: dateUpload, views: views)
    }
}

extension PhotoModel: Equatable {
    static func == (lhs: PhotoModel, rhs: PhotoModel) -> Bool {
        return lhs.url == rhs.url
    }
}
