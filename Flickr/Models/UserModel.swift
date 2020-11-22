//
//  UserModel.swift
//  Flickr
//
//  Created by matt_spb on 01.04.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import Foundation

struct UserCodable: Codable {
    let person: Person
}

class Person: Codable {
    let id: String
    var nsid: String? = nil
    let iconserver: String
    let iconfarm: Int
    var userPicUrl: String? = nil
    
    var iconServer: Int {
        guard let iconServer = Int(iconserver) else { return 0 }
        return iconServer
    }
    
    init(id: String, iconserver: String, iconfarm: Int) {
        self.id = id
        self.iconserver = iconserver
        self.iconfarm = iconfarm
    }
    
    convenience init(with photo: Photo) {
        let id = photo.owner
        let iconserver = photo.iconserver
        let iconfarm = photo.iconfarm
        
        self.init(id: id, iconserver: iconserver, iconfarm: iconfarm)
    }
}


/*
let json = ["person": ["id": "80036114@N08",
                       "nsid": "80036114@N08",
                       "ispro": 1,
                       "can_buy_pro": 0,
                       "iconserver": "8669",
                       "iconfarm": 9,
                       "path_alias": "normanwest4tography",
                       "has_stats":"1",
                       "pro_badge": "standard",
                       "expire":"0",
                       "username": ["_content": "normanwest4tography"],
                       "realname": ["_content" : "Norman West"],
                       "location": ["_content":"South Wales, UK."],
                       "timezone": ["label": "GMT: Dublin, Edinburgh, Lisbon, London",
                                    "offset": "+00:00",
                                    "timezone_id": "EuropeLondon"],
                       "description": ["_content": "Hello and welcome to my Flickr site. I am a keen amateur with a passion for photographing all aspects of wildlife and landscapes. Based in South Wales, the majority of wildlife photographs are from the local area./nNow retired, visits further afield are planned and as such this website is a work in progress."],
                       "photosurl": ["_content": "https:www.flickr.com/photos_normanwest4tography"],
                       "profileurl" : ["_content": "https:www.flickr.com/people/normanwest4tography"],
                       "mobileurl": ["_content": "https:m.flickr.com/photostream.gne?id=79943301"],
                       "photos": ["firstdatetaken": ["_content": "2000-01-01 00:00:46"],
                                  "firstdate": ["_content":"1338990226"],
                                  "count": ["_content": 2818]]],
            "stat": "ok"] as [String : Any]
*/
