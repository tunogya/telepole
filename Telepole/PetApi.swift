//
//  Pets.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/27.
//
import Alamofire
import Foundation
import SwiftyJSON

struct PetModel: Codable {
    var id: String
    var name: String
    var username: String
    var description: String
    var profile_image_url: String
    var protected: Bool
    var verified: Bool
    var variety: String
    var gender: String
}

struct PetMetricsModel {
    var followers_count = 0
    var following_count = 0
    var meow_coin_count = 0
    var pet = ""
}

class PetApi {
//    根据用户id查询用户信息
    func getPetById(_ id: String, completion: @escaping (PetModel) -> ()) {
        let url = "\(HOSTNAME)/telepole/v1.0/pets/\(id)/"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)["data"]
                completion(PetModel(
                    id: jsonData["_id"].stringValue,
                    name: jsonData["description"].stringValue,
                    username: jsonData["name"].stringValue,
                    description: jsonData["variety"].stringValue,
                    profile_image_url: jsonData["profile_image_url"].stringValue,
                    protected: jsonData["protected"].boolValue,
                    verified: jsonData["verified"].boolValue,
                    variety: jsonData["variety"].stringValue,
                    gender: jsonData["gender"].stringValue
                ))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
//    用户注册
    func createPet(_ pet: PetModel, completion: @escaping (PetModel) -> ()) {
        let parameters: [String: Array<Any>] = ["data": [["name": pet.name, "username": pet.username, "description": pet.description, "profile_image_url": pet.profile_image_url, "protected": pet.protected, "verified": pet.verified, "gender": pet.gender, "variety": pet.variety]]]
        let url = "\(HOSTNAME)/telepole/v1.0/pets/"
        AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let id = JSON(value)["ids"][0].stringValue
                self.getPetById(id) { (pet) in
                    completion(pet)
                }
                self.updatePetMetrics(PetMetricsModel(followers_count: 0, following_count: 0, meow_coin_count: 0, pet: id))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
//    照片上传
    func uploadProfileImage() {
        
    }
    
    func getPetMetricsModel(_ id: String, completion: @escaping (PetMetricsModel) -> ()){
        let parameters: [String: Any] = ["query": ["pet": ["$eq": id]]]
        let url = "\(HOSTNAME)/telepole/v1.0/pets_public_metrics/find/"
        AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let pet = JSON(value)["data"][0]["pet"]["_id"].stringValue
                let followers_count = JSON(value)["data"][0]["followers_count"].intValue
                let following_count = JSON(value)["data"][0]["following_count"].intValue
                let meow_coin_count = JSON(value)["data"][0]["meow_coin_count"].intValue
                completion(PetMetricsModel(followers_count: followers_count, following_count: following_count, meow_coin_count: meow_coin_count, pet: pet))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func updatePetMetrics(_ metric: PetMetricsModel) -> Void {
        let url = "\(HOSTNAME)/telepole/v1.0/pets_public_metrics/"
        let parameters: [String: Array<Any>] = ["data": [["pet": metric.pet, "followers_count": metric.followers_count, "following_count": metric.following_count, "meow_coin_count":metric.meow_coin_count]]]
        AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(_):
                print("ok")
            }
        }
    }
}
