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
                let locations = JSON(value)["locations"].stringValue
                completion(locations)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
