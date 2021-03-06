//
//  LocationModel.swift
//  Telepole
//
//  Created by 丁涯 on 2021/1/23.
//

import Alamofire
import Foundation
import SwiftyJSON

struct Geo: Identifiable {
    var id: String = ""
    var pet: Pet = Pet()
    var name: String = "佚名"
    var latitude: Double = 0
    var longitude: Double = 0
    var geo_code: String = ""
    var _createTime: Double = Date().timeIntervalSince1970
}

extension Geo {
    // 上传我的位置
    func postMyGeo(_ geo: Geo, completion: @escaping () -> ()) {
        AMap().convertCoordinate(longitude: geo.longitude, latitude: geo.latitude) { locationsString in
            let url = "\(HOSTNAME)/geo/"
            let locations = locationsString.split(separator: ",")
            let parameters: [String: Array<Any>] = ["data": [["latitude": locations[1], "longitude": locations[0], "name": geo.name, "pet": geo.pet.id, "geo_code": Geohash.encode(latitude: latitude, longitude: longitude, length: 12) ,"_createTime": geo._createTime]]]
           
            AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    completion()
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    func getLastGeos(petID: Pet.ID, completion: @escaping ([Geo]) -> ()){
        let url = "\(HOSTNAME)/geo/find/?limit=10"
        let parameters: [String: Any] = ["query":["pet": ["$eq": petID]]]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let items = JSON(value)["data"].arrayValue
                let geos: [Geo] = items.map { item in
                    Geo(id: item["_id"].stringValue,
                        pet: Pet(id: item["pet"]["_id"].stringValue,
                                 name: item["pet"]["name"].stringValue,
                                 description: item["pet"]["description"].stringValue,
                                 profile_image_url: item["pet"]["profile_image_url"].stringValue,
                                 protected: item["pet"]["protected"].boolValue,
                                 verified: item["pet"]["verified"].boolValue,
                                 variety: item["pet"]["variety"].stringValue,
                                 gender: item["pet"]["gender"].stringValue,
                                 phone: item["pet"]["phone"].stringValue,
                                 coins: item["pet"]["coins"].doubleValue,
                                 _createTime: item["pet"]["_createTime"].doubleValue),
                        name: item["name"]["fullName"].stringValue,
                        latitude: item["latitude"].doubleValue,
                        longitude: item["longitude"].doubleValue,
                        geo_code: item["geo_code"].stringValue,
                        _createTime: item["_createTime"].doubleValue)
                }
                completion(geos)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func deleteOneGeo(_ geo: Geo, completion: @escaping () -> ()) {
        let url = "\(HOSTNAME)/geo/\(geo.id)"
        AF.request(url, method: .delete).responseJSON { response in
            switch response.result {
            case .success(_):
                completion()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func deleteAllGeo(_ me: Pet, completion: @escaping () -> ()) {
        let url = "\(HOSTNAME)/geo"
        let parameters: [String: Any] = ["query": ["pet": ["$eq": me.id]]]
        AF.request(url, method: .delete, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { response in
            switch response.result {
            case .success(_):
                completion()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // 获取我附近的宠物
    func getNearbyPets(latitude: Double, longitude: Double, my: Pet,completion: @escaping ([Geo]) -> ()) {
        let url = "\(HOSTNAME)/geo/find/"
        let parameters: [String: Any] = ["query":["$and":[["latitude": ["$lte": latitude + 0.01]],
                                                          ["latitude": ["$gte": latitude - 0.01]],
                                                          ["longitude": ["$lte": longitude + 0.01]],
                                                          ["longitude": ["$gte": longitude - 0.01]],
                                                          ["pet": ["$nin": [my.id]]]]]]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { (respone) in
            switch respone.result {
            case .success(let value):
                let items = JSON(value)["data"].arrayValue
                let geos: [Geo] = items.map { item in
                    Geo(id: item["_id"].stringValue,
                        pet: Pet(id: item["pet"]["_id"].stringValue,
                                 name: item["pet"]["name"].stringValue,
                                 description: item["pet"]["description"].stringValue,
                                 profile_image_url: item["pet"]["profile_image_url"].stringValue,
                                 protected: item["pet"]["protected"].boolValue,
                                 verified: item["pet"]["verified"].boolValue,
                                 variety: item["pet"]["variety"].stringValue,
                                 gender: item["pet"]["gender"].stringValue,
                                 phone: item["pet"]["phone"].stringValue,
                                 coins: item["pet"]["coins"].doubleValue,
                                 _createTime: item["pet"]["_createTime"].doubleValue),
                        name: item["name"]["fullName"].stringValue,
                        latitude: item["latitude"].doubleValue,
                        longitude: item["longitude"].doubleValue,
                        geo_code: item["geo_code"].stringValue,
                        _createTime: item["_createTime"].doubleValue)
                }
                completion(geos)
            case .failure(let error):
                print(error)
            }
        }
    }
}
