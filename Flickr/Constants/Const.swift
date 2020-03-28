//
//  Const.swift
//  Flickr
//
//  Created by matt_spb on 24.02.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import Foundation

struct Const {
    
    struct API_const {
        //static let token = "aa0d8bc526d857a0ec0f10bab4ab3c83"
        static let token = "6c2f46d3c0edd903dd8b0ff333c94548"
        //static let token = "1e6631b7f664d026a8f5bf049d45bc3f"
        static let baseURL = "https://api.flickr.com/services/rest/"
    }
    
    enum Screen {
        case tape
        case collection
        
        var per_page: Int {
            switch self {
            case .tape:
                return 10
            case .collection:
                return 50
            }
        }
    }
}
