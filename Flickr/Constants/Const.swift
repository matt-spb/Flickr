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
        static let token = "6c2f46d3c0edd903dd8b0ff333c94548"
        static let baseURL = "https://flickr.com/services/rest/"
    }
    
    enum Screen {
        case tape
        case collection
        
        var per_page: Int {
            switch self {
            case .tape:
                return 20
            case .collection:
                return 50
            }
        }
    }
}
