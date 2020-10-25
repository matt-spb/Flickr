//
//  PhotoModel.swift
//  Flickr
//
//  Created by matt_spb on 24.02.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import UIKit

struct PhotoMod: Codable {
    let photos: Photos
}

// при смене разрешения урл_н в запросе полетят поля в модели

struct Photos: Codable {
    let pages: Int
    let photo: [Photo]
}


struct Photo: Codable {
    let owner: String
    let ownername: String
    let title: String
    let dateupload: String
    let iconserver: String
    let iconfarm: Int
    let views: String
    let url_n: String
    let height_n: Int
    let width_n: Int
//    var user: Person?
    var userPicUrl: String?
    
    var url: String {
        return url_n
    }
    
    var url_c: String {
        get {
            var str = url
            let lastPeriodIndex = str.lastIndex(of: ".")
            str.remove(at: str.index(before: lastPeriodIndex!))
            str.insert("c", at: str.index(before: lastPeriodIndex!))
            
            return str
        }
    }
    
    var viewS: Int {
        guard let viewS = Int(views) else { return 0 }
        return viewS
    }
    
    var dateUpload: Double {
        guard let dateUpload = Double(dateupload) else { return 0 }
        return dateUpload
    }
    
    var height: Int {
        return height_n
    }
    
    var width: Int {
        return width_n
    }
    
    var iconServer: Int {
        guard let iconServer = Int(iconserver) else { return 0 }
        return iconServer
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.url == rhs.url
    }
}

/*
 что приходит в джейсоне
let photoModel = ["photos": ["page": 1,
                             "pages": 500,
                             "perpage": 1,
                             "total": 500,
                             "photo": [["id": "50500774196",
                                        "owner":"137893408@N06",
                                        "secret": "5f83834cef",
                                        "server":"65535",
                                        "farm":66,
                                        "title": "Wonderful autumn",
                                        "ispublic": 1, "isfriend": 0,
                                        "isfamily":0,
                                        "dateupload": "1603011553",
                                        "ownername":"Jean-Luc Peluchon",
                                        "iconserver": "899",
                                        "iconfarm": 1,
                                        "views": "88078",
                                        "latitude": "45.680654",
                                        "longitude":"0.272727",
                                        "accuracy": "15",
                                        "context": 0,
                                        "place_id":"",
                                        "woeid":"6453707",
                                        "geo_is_public": 1,
                                        "geo_is_contact": 0,
                                        "geo_is_friend":0,
                                        "geo_is_family":0,
                                        "url_n": "https:blablabla_n.jpg",
                                        "height_n": 180,
                                        "width_n":320]]],
                  "stat":"ok"] as [String : Any]
*/
