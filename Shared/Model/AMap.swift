//
//  AMap.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class AMap {
    let key = "e71e614c4b382ad78cb2b66c879771e2"
    
    func convertCoordinate(longitude: Double, latitude: Double, coordsys: String="gps", completion: @escaping (String) -> ()) {
        let url = "https://restapi.amap.com/v3/assistant/coordinate/convert?key=\(key)&locations=\(longitude),\(latitude)&coordsys=\(coordsys)"
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let location = JSON(value)["locations"].stringValue
                completion(location)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func reverseGeocode(latitude: Double, longitude: Double, completion: @escaping (String) -> ()) {
        let la = String(format: "%0.6f", latitude)
        let lo = String(format: "%0.6f", longitude)
        let url = "https://restapi.amap.com/v3/geocode/regeo?key=\(key)&location=\(lo),\(la)"
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                var location = JSON(value)["regeocode"]["formatted_address"].stringValue
                if location.isEmpty{
                    location = "\(lo),\(la)"
                }
                completion(location)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
