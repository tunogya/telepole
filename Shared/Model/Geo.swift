//
//  LocationModel.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/23.
//

import Alamofire
import Foundation
import SwiftyJSON

struct Geo {
    var pet: Pet
    var name: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
}

extension Geo {
    // 上传我的位置
    func postMyGeo(_ geo: Geo) {
        let url = "\(HOSTNAME)/geo/"
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
    func getNearbyPets(latitude: Double, longitude: Double, completion: @escaping ([Geo]) -> ()) {
        let url = "\(HOSTNAME)/geo/find/"
        let parameters: [String: Any] = ["query":["$and":[["latitude": ["$lte": latitude + 0.01]], ["latitude": ["$gte": latitude - 0.01]], ["longitude": ["$lte": longitude + 0.01]], ["longitude": ["$gte": longitude - 0.01]]]]]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let items = JSON(value)["data"].arrayValue
                var geos: [Geo] = []
                for item in items {
                    let pet = Pet(id: item["pet"]["_id"].stringValue,
                                       name: item["pet"]["name"].stringValue,
                                       description: item["pet"]["description"].stringValue,
                                       profile_image_url: item["pet"]["profile_image_url"].stringValue,
                                       protected: item["pet"]["protected"].boolValue,
                                       verified: item["pet"]["verified"].boolValue,
                                       variety: item["pet"]["variety"].stringValue,
                                       gender: item["pet"]["gender"].stringValue,
                                       phone: item["pet"]["phone"].stringValue,
                                       coins: item["pet"]["coins"].doubleValue)
                    let geo: Geo = Geo(pet: pet,
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
