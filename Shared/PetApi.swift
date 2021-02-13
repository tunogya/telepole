//
//  Pets.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/27.
//
import Alamofire
import Foundation
import SwiftyJSON

struct PetModel: Identifiable, Codable {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var profile_image_url: String = ""
    var protected: Bool = false
    var verified: Bool = false
    var variety: String = ""
    var gender: String = "boy"
    var phone: String = ""
    var coins: Double = 0
}

class PetApi {
//    根据pet id查询用户信息
    func getPetByID(_ doc_id: String, completion: @escaping (PetModel) -> ()) {
        let url = "\(HOSTNAME)/telepole/v1.0/pets/\(doc_id)/"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)["data"]
                completion(PetModel(
                    id: jsonData["_id"].stringValue,
                    name: jsonData["name"].stringValue,
                    description: jsonData["description"].stringValue,
                    profile_image_url: jsonData["profile_image_url"].stringValue,
                    protected: jsonData["protected"].boolValue,
                    verified: jsonData["verified"].boolValue,
                    variety: jsonData["variety"].stringValue,
                    gender: jsonData["gender"].stringValue,
                    phone: jsonData["phone"].stringValue,
                    coins: jsonData["coins"].doubleValue
                ))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
//   宠物注册
    func createPet(_ pet: PetModel, completion: @escaping (PetModel) -> ()) {
        let parameters: [String: Array<Any>] = ["data": [["name": pet.name, "description": pet.description, "profile_image_url": pet.profile_image_url, "protected": pet.protected, "verified": pet.verified, "gender": pet.gender, "variety": pet.variety, "phone": pet.phone, "coins": pet.coins]]]
        let url = "\(HOSTNAME)/telepole/v1.0/pets/"
        
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
}
