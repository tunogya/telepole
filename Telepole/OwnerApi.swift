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
    // 文档_id
    var _id: String = ""
    // 宠物列表
    var pets: [String] = []
    // 用户的文档_id
    var user_id: String = ""
}

class OwnerApi {
    // 查询是否有云端备份数据，有则下载
    func getPetByUser(_id doc_id: String, completion: @escaping (OwnerModel) -> ()) {
        let url = "\(HOSTNAME)/telepole/v1.0/owner/find/"
        let parameters: [String: Any] = ["query": ["user": ["$eq": doc_id]]]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let user_id = JSON(value)["data"][0]["user"]["user"].stringValue
                let _id = JSON(value)["data"][0]["_id"].stringValue
                let petsArray = JSON(value)["data"][0]["pets"].arrayValue
                var pets: [String] = []
                for pet in petsArray {
                    pets.append(pet["_id"].stringValue)
                }
                completion(OwnerModel(_id: _id, pets: pets, user_id: user_id))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // 创建一份云端备份数据
    func initCloudData(_ owner: OwnerModel){
        let url = "\(HOSTNAME)/telepole/v1.0/owner/"
        let parameters: [String: Array<Any>] = ["data": [["pets": owner.pets, "user": owner.user_id]]]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                debugPrint(value)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // 更新云端数据
    func patchCloudData(_id doc_id: String, owner: OwnerModel){
        let url = "\(HOSTNAME)/telepole/v1.0/owner/\(doc_id)/"
        let parameters: [String: Array<Any>] = ["data": [["pets": owner.pets, "user": owner.user_id]]]
        
        AF.request(url, method: .patch, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                debugPrint(value)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

