//
//  Pets.swift
//  Telepole
//
//  Created by 丁涯 on 2020/12/27.
//
import Alamofire
import Foundation
import SwiftyJSON

let HOSTNAME = "https://app.wakanda.vip"

struct User: Identifiable {
    var id = UUID()
    var code: String
    var name: String
    var username: String
    var description: String
    var profile_image_url: String
    var protected: Bool
    var verified: Bool
    var variety: String
    var gender: String
}

class UsersApi {
    func getUserByCode(code: String, completion: @escaping (User) -> ()) {
        let url = "\(HOSTNAME)/telepole/v1.0/users/\(code)"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)["data"]
                completion(User(
                    code: jsonData["_id"].stringValue,
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
                print(error)
                return
            }
        }
    }
}
