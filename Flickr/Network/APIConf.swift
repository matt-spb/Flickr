//
//  APIConf.swift
//  Flickr
//
//  Created by matt_spb on 24.02.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import Foundation

class APIConf {
    
    class func createRequest(withURL url: String, andParams params: [String: AnyHashable]) -> URLRequest {
        
        var url = url + "?"
        
        for (key, value) in params {
            url += key + "=" + "\(value)" + "&"
        }
        
        url = String(url.dropLast())
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"  //метод запроса
        
        return request
    }
    
    
    class func generalComplitionHandler(withData data: Data?,
                                        withError requestError: Error?,
                                        success: (_ json: Any) -> Void,
                                        failure: (_ errorDescription: String) -> Void) {
        if let error = requestError {
            failure(error.localizedDescription)
        }
        
        guard let data = data else {
            failure("Data is nil")
        return
    }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            success(json)
        } catch {
            failure("Ошибка сериализации")
            return
        }
    }
}
