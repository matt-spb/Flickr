//
//  APIConf.swift
//  Flickr
//
//  Created by matt_spb on 24.02.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import Foundation

struct APIConf {
    
    static func createRequest(withURL url: String, andParams params: [String: AnyHashable]) -> URLRequest {
        
        var url = url + "?"
        
        for (key, value) in params {
            url += key + "=" + "\(value)" + "&"
        }
        
        url = String(url.dropLast())
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"  //метод запроса
        
        return request
    }
}
