//
//  LocationModel.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/23.
//

import Alamofire
import Foundation
import SwiftyJSON

struct GeoModel {
    var pet: PetModel
    var name: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
}

class GeoApi {
    // 上传我的位置
    func postMyGeo(_ geo: GeoModel) {
        let url = "\(HOSTNAME)/telepole/v1.0/geo/"
        let parameters: [String: Array<Any>] = ["data": [["latitude": geo.latitude, "longitude": geo.longitude, "name": geo.name, "pet": geo.pet.id]]]
       
        AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let id = JSON(value)["ids"][0].stringValue
                debugPrint(id)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // 获取我附近的宠物
    func getNearbyPets(latitude: Double, longitude: Double, completion: @escaping ([GeoModel]) -> ()) {
        let url = "\(HOSTNAME)/telepole/v1.0/geo/find/"
        let parameters: [String: Any] = ["query":["$and":[["latitude": ["$lte": latitude + 0.01]], ["latitude": ["$gte": latitude - 0.01]], ["longitude": ["$lte": longitude + 0.01]], ["longitude": ["$gte": longitude - 0.01]]]]]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let items = JSON(value)["data"].arrayValue
                var geos: [GeoModel] = []
                for item in items {
                    let pet = PetModel(id: item["pet"]["_id"].stringValue,
                                       name: item["pet"]["name"].stringValue,
                                       description: item["pet"]["description"].stringValue,
                                       profile_image_url: item["pet"]["profile_image_url"].stringValue,
                                       protected: item["pet"]["protected"].boolValue,
                                       verified: item["pet"]["verified"].boolValue,
                                       variety: item["pet"]["variety"].stringValue,
                                       gender: item["pet"]["gender"].stringValue)
                    let geo: GeoModel = GeoModel(pet: pet,
                                                 name: item["name"].stringValue,
                                                 latitude: item["latitude"].doubleValue,
                                                 longitude: item["longitude"].doubleValue)
                    geos.append(geo)
                }
                completion(geos)
            case .failure(let error):
                print(error)
            }
        }
    }
}
