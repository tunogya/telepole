//
//  OwnerApi.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/6.
//

import Alamofire
import Foundation
import SwiftyJSON

struct OwnerModel {
    var pets: [String] = []
    var user: String = ""
}

class OwnerApi {
    // 查询是否有云端备份数据，有则下载
    // id是数据库存储的user-id，非user
    func getPetByUser(_ id: String, completion: @escaping (OwnerModel) -> ()) {
        let url = "\(HOSTNAME)/telepole/v1.0/owner/find/"
        let parameters: [String: Any] = ["query": ["user": ["$eq": id]]]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let user = JSON(value)["data"][0]["user"]["user"].stringValue
                let petsArray = JSON(value)["data"][0]["pets"].arrayValue
                var pets: [String] = []
                for pet in petsArray {
                    pets.append(pet["_id"].stringValue)
                }
                completion(OwnerModel(pets: pets, user: user))
            case .failure(let error):
                debugPrint(error)
            }
        }
        
        
    }
    
    // 创建一份云端备份数据
    func initCloudData(owner: OwnerModel){
        let url = "\(HOSTNAME)/telepole/v1.0/owner/"
        let parameters: [String: Array<Any>] = ["data": [["pets": owner.pets, "user": owner.user]]]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                debugPrint(value)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // 上传到云端
//    func updateCloudData(user: String, pets: [String]){
//        let url = "\(HOSTNAME)/telepole/v1.0/owner/"
//        let parameters: [String: Array<Any>] = ["data": [["name": pet.name, "description": pet.description, "profile_image_url": pet.profile_image_url, "protected": pet.protected, "verified": pet.verified, "gender": pet.gender, "variety": pet.variety, "phone": pet.phone, "coins": pet.coins]]]
//    }
    
    
}

