//
//  UInt+Ext.swift
//  Flickr
//
//  Created by matt_spb on 04.04.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import Foundation

extension Double {
    
    func convertToDateString() -> String {        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = .current
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
