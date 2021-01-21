//
//  Pets.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/27.
//
import Alamofire
import Foundation
import SwiftyJSON

struct PetModel {
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

class PetApi {
//    根据用户id查询用户信息
    func getPetById(id: String, completion: @escaping (PetModel) -> ()) {
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
                self.getPetById(id: id) { (pet) in
                    completion(pet)
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
        
    }
    
//    照片上传
    func uploadProfileImage() {
        
    }
}
