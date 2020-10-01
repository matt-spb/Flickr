//
//  UserModel.swift
//  Flickr
//
//  Created by matt_spb on 01.04.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    
    let id: String
    let ownerName: String
    let iconServer: Int
    let iconFarm: String
    var nsid: String?
    var userPicUrl: String?
    
    
    init(id: String, ownerName: String, iconServer: Int, iconFarm: String) {
        self.id = id
        self.ownerName = ownerName
        self.iconServer = iconServer
        self.iconFarm = iconFarm
    }
    
    
    convenience init(with json: JSON) {
        let id          = json["owner"].stringValue
        let ownerName   = json["ownername"].stringValue
        let iconServer  = json["iconserver"].intValue
        let iconFarm    = json["iconfarm"].stringValue
        
        self.init(id: id, ownerName: ownerName, iconServer: iconServer, iconFarm: iconFarm)
    }
}

