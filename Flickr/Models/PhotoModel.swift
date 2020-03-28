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
    
    let title: String?
    let width: Double
    let height: Double
    let url: String
    var url_c: String {
        get {
            var str = url
            let lastPeriodIndex = str.lastIndex(of: ".")
            str.remove(at: str.index(before: lastPeriodIndex!))
            str.insert("c", at: str.index(before: lastPeriodIndex!))
            
            return str
        }
    }
    let iconServer: Int
    let userID: String
    let latitude: Int
    let longitude: Int
    let dateUpload: String
    let views: String
    
    init(title: String?, width: Double, height: Double, url: String, iconServer: Int, userID: String, latitude: Int, longitude: Int, dateUpload: String, views: String) {
        self.title          = title
        self.width          = width
        self.height         = height
        self.url            = url
        self.iconServer     = iconServer
        self.userID         = userID
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
        let iconServer  = json["iconServer"].intValue
        let userID      = json["owner"].stringValue
        let latitude    = json["latitude"].intValue
        let longitude   = json["longitude"].intValue
        let dateUpload  = json["dateUpload"].stringValue
        let views       = json["views"].stringValue
        
        self.init(title: title, width: width, height: height, url: url, iconServer: iconServer, userID: userID, latitude: latitude, longitude: longitude, dateUpload: dateUpload, views: views)
    }
}

/*
let id: String
let owner: String
let secret: String
let server: String
let farm: Int
 
 let id = json["id"].stringValue
 let owner = json["owner"].stringValue
 let secret = json["secret"].stringValue
 let server = json["server"].stringValue
 let farm = json["farm"].intValue
*/
