//
//  OwnerApi.swift
//  Telepole
//
//  Created by 丁涯 on 2021/2/6.
//

import Alamofire
import Foundation
import SwiftyJSON

struct Owner {
    // 文档_id
    var id: String = ""
    // 宠物列表
    var pets: [String] = []
    // 用户的文档_id
    var user_id: String = ""
}

class OwnerApi {
    // 查询是否有云端备份数据，有则下载
    func getDataByUser_id(_id doc_id: String, completion: @escaping (Owner) -> ()) {
        let url = "\(HOSTNAME)/telepole/v1.0/owner/find/"
        let parameters: [String: Any] = ["query": ["user": ["$eq": doc_id]]]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let user_id = JSON(value)["data"][0]["user"]["_id"].stringValue
                let _id = JSON(value)["data"][0]["_id"].stringValue
                let petsArray = JSON(value)["data"][0]["pets"].arrayValue
                var pets: [String] = []
                for pet in petsArray {
                    pets.append(pet["_id"].stringValue)
                }
                completion(Owner(id: _id, pets: pets, user_id: user_id))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // 创建一份云端备份数据
    func initData(_ owner: Owner, completion: @escaping (Owner) -> ()){
        let url = "\(HOSTNAME)/telepole/v1.0/owner/"
        let parameters: [String: Array<Any>] = ["data": [["pets": owner.pets, "user": owner.user_id]]]
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let doc_id = JSON(value)["ids"][0].stringValue
                self.getData(_id: doc_id) { (owner) in
                    completion(owner)
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // 更新云端数据
    func patchData(_id doc_id: String, owner: Owner, completion: @escaping () -> ()){
        let url = "\(HOSTNAME)/telepole/v1.0/owner/\(doc_id)/"
        let parameters: [String: Any] = ["data": ["pets": owner.pets, "user": owner.user_id]]
        
        AF.request(url, method: .patch, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(_):
                completion()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // 获取指定云端备份
    func getData(_id doc_id: String, completion: @escaping (Owner) -> ()) {
        let url = "\(HOSTNAME)/telepole/v1.0/owner/\(doc_id)/"
        
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                let user_id = JSON(value)["data"]["user"]["_id"].stringValue
                let _id = JSON(value)["data"]["_id"].stringValue
                let petsArray = JSON(value)["data"]["pets"].arrayValue
                var pets: [String] = []
                for pet in petsArray {
                    pets.append(pet["_id"].stringValue)
                }
                completion(Owner(id: _id, pets: pets, user_id: user_id))
            case .failure(let error):
                debugPrint(error)
            }
        }
        
    }
    
}

