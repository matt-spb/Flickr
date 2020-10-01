//
//  APIWrapper.swift
//  Flickr
//
//  Created by matt_spb on 24.02.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIWrapper {
    
    class func getFullInfoPhoto(page: Int, per_page: Int, success: @escaping (_ json: Any) -> Void, failure: @escaping (_ error: String?) -> Void) {
        let url = Const.API_const.baseURL
        let params: [String: AnyHashable] = [
            "method":   "flickr.interestingness.getList",
            "api_key":  Const.API_const.token,
            "format":   "json",
            "page":     page,
            "per_page": per_page,
            "nojsoncallback": 1,
            "extras": "date_upload,owner_name,icon_server,geo,views,url_n"
        ]
    
        let request: URLRequest = APIConf.createRequest(withURL: url, andParams: params)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            APIConf.generalComplitionHandler(withData: data, withError: error, success: success, failure: failure)
        }
        
        dataTask.resume()
    }
    
    
    class func getUserNsid(for id: String, completion: @escaping (Result<String, ErrorMessage>) -> Void) {
        let url = Const.API_const.baseURL
        let params: [String: AnyHashable] = [
            "method":   "flickr.people.getInfo",
            "api_key":  Const.API_const.token,
            "format":   "json",
            "user_id": id,
            "nojsoncallback": 1
        ]
    
        let request: URLRequest = APIConf.createRequest(withURL: url, andParams: params)
        //print(request)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(.failure(.unableToComplete))
                }
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let jsonData = JSON(json)
                let nsid = jsonData["person"]["nsid"].stringValue
                
                DispatchQueue.main.async {
                    completion(.success(nsid))
                }
            } catch {
                completion(.failure(.invalidData))
                return
            }
        }
        
        dataTask.resume()
    }

    
    class func getUserPic(iconFarm: String, iconServer: Int, nsid: String, success: @escaping (_ json: Any) -> Void, failure: @escaping (_ error: String?) -> Void) {
        let iconServer = String(iconServer)
        let address = "http://farm\(iconFarm).staticflickr.com/\(iconServer)/buddyicons/\(nsid).jpg"
        var request = URLRequest(url: URL(string: address)!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            APIConf.generalComplitionHandler(withData: data, withError: error, success: success, failure: failure)
        }
        dataTask.resume()
    }
}



//напрашивается в начальном запросе получить гео(потому что его нет в гет инфо фотос) и ай ди. И для каждой фотки уже дернуть гет инфо, распарсить в модель данных и по ай ди получить урл для загрузки картинки

//хотя не, для некторых фоток приходит полное инфо, кроме локейшн. Локейшн сделать в виде кнопки с названием из инфо, а по нажатию сделать открытие maps и передать туда координаты широты и долготы

//а вообще то можно и ленту пиздатую запилить как в приложении. для этого нужно сделать верстку ячейки и передавать туда нужные данные

//если iconserver > 0, то можно получить userpic Buddyicons, nsid можно получить из гет инфо. в гетлист эта строка не приходит, если 0, то сделать дефолтный юзерпик

// тэги по сути нафиг не нужны, в приле они не отображаются

//description, license, date_upload, date_taken, owner_name, icon_server, original_format, last_update, geo, tags, machine_tags, o_dims, views, media, path_alias, url_sq, url_t, url_s, url_q, url_m, url_n, url_z, url_c, url_l, url_o
