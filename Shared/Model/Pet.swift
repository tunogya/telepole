//
//  Pets.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/27.
//
import Alamofire
import Foundation
import SwiftyJSON

struct Pet: Identifiable, Codable, Equatable, Hashable {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var profile_image_url: String = ""
    var protected: Bool = true
    var verified: Bool = false
    var variety: String = ""
    var gender: String = "boy"
    var phone: String = ""
    var coins: Double = 0
    var _createTime: Double = Date().timeIntervalSince1970
}

// Pet API
extension Pet {
    var petname: String {
        if id == "" {
            return "暂无宠物"
        }
        return name
    }
    
//    根据pet id查询用户信息
    func getPetByID(_ doc_id: String, completion: @escaping (Pet) -> ()) {
        let url = "\(HOSTNAME)/pets/\(doc_id)/"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)["data"]
                completion(Pet(
                    id: jsonData["_id"].stringValue,
                    name: jsonData["name"].stringValue,
                    description: jsonData["description"].stringValue,
                    profile_image_url: jsonData["profile_image_url"].stringValue,
                    protected: jsonData["protected"].boolValue,
                    verified: jsonData["verified"].boolValue,
                    variety: jsonData["variety"].stringValue,
                    gender: jsonData["gender"].stringValue,
                    phone: jsonData["phone"].stringValue,
                    coins: jsonData["coins"].doubleValue,
                    _createTime: jsonData["_createTime"].doubleValue)
                )
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
//   宠物注册
    func createPet(_ pet: Pet, completion: @escaping (Pet) -> ()) {
        let parameters: [String: Array<Any>] = ["data": [["name": pet.name, "description": pet.description, "profile_image_url": pet.profile_image_url, "protected": pet.protected, "verified": pet.verified, "gender": pet.gender, "variety": pet.variety, "phone": pet.phone, "coins": pet.coins, "_createTime": pet._createTime]]]
        let url = "\(HOSTNAME)/pets/"
        
        AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let id = JSON(value)["ids"][0].stringValue
                self.getPetByID(id) { (pet) in
                    completion(pet)
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // 关闭保护
    func closedProtected(_ pet: Pet, completion: @escaping () -> ()) {
        let parameters: [String: Any] = ["data": ["$set": ["protected": false]]]
        let url = "\(HOSTNAME)/pets/\(pet.id)"
        AF.request(url, method: .patch, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(_):
                completion()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // 开启保护
    func openProtected(_ pet: Pet, completion: @escaping () -> ()) {
        let parameters: [String: Any] = ["data": ["$set": ["protected": true]]]
        let url = "\(HOSTNAME)/pets/\(pet.id)"
        AF.request(url, method: .patch, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(_):
                completion()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    // 投币
    func vote(pet: Pet, coin: Double, completion: @escaping () -> ()) {
        let parameters: [String: Any] = ["data": ["$set": ["coins": pet.coins + coin]]]
        let url = "\(HOSTNAME)/pets/\(pet.id)"
        AF.request(url, method: .patch, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(_):
                completion()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
}
